###########################################################
# PBIS Dataset Refresh
# ---------------------------------------------------------
# Trigger a dataset refresh in service
#
# Created:  2024-10-04, filipkraus.net
# #########################################################

cls
Set-ExecutionPolicy RemoteSigned -Force # Skip user prompt

###########################################################
# Select account

Write-Host ">> Step 1: Authenticate in Power BI Service"

$UserAdmin = "admin@domain.com"
$UserChoice = [System.Management.Automation.Host.ChoiceDescription[]](@(
    (New-Object System.Management.Automation.Host.ChoiceDescription("&Admin", $UserAdmin)),
    (New-Object System.Management.Automation.Host.ChoiceDescription("&Other", "custom"))
))
$UserSel = $Host.Ui.PromptForChoice("Account", "Choose the account", $UserChoice, 0)
Switch ($UserSel) {
    0 {$User = $UserAdmin}
    1 {$User = Read-Host -Prompt "Enter account email"}
}
write-host "Signing in as '$($User)'"

###########################################################
# Authenticate

$Pass = Read-Host -Prompt "Enter password for '$($User)'" -AsSecureString
#$Pass = ConvertTo-SecureString "" -AsPlainText -Force # For testing only
$Cred = New-Object System.Management.Automation.PSCredential($User,$Pass)

Write-Progress 'Signing in' -Status '...'
Connect-PowerBIServiceAccount -Credential $Cred
Write-Progress -Complete '(unused)'

###########################################################
# Choose a workspace

Write-Host ">> Step 2: Select Workspace"
Write-Progress 'Fetching workspaces' -Status '...'
$Workspaces = Invoke-PowerBIRestMethod -Url "https://api.powerbi.com/v1.0/myorg/groups" -Method Get | ConvertFrom-Json
Write-Progress -Complete '(unused)'
$Workspace = $Workspaces.value `
    | Select-Object -Property id, name `
    | Out-Gridview -Title "Select Workspace" -OutputMode Single
Write-Host "Selected: $($Workspace.name) ($($Workspace.id))"

###########################################################
# Choose a dataset

Write-Host "`n>> Step 3: Select Dataset"
Write-Progress 'Fetching datasets' -Status '...'
$Datasets = Invoke-PowerBIRestMethod -Url "https://api.powerbi.com/v1.0/myorg/groups/$($Workspace.id)/datasets/" -Method Get | ConvertFrom-Json
Write-Progress -Complete '(unused)'
$Dataset = $Datasets.value `
    | Select-Object -Property id, name, configuredBy, isRefreshable `
    | Out-Gridview -Title "Select Dataset" -OutputMode Single
Write-Host "Selected: $($Dataset.name) ($($Dataset.id))"

###########################################################
# Trigger a refresh

Write-Host "`n>> Step 4: Submit a refresh request"

$Url = "https://api.powerbi.com/v1.0/myorg/groups/$($Workspace.id)/datasets/$($Dataset.id)/refreshes"
$Body = @{
        "notifyOption"="MailOnCompletion"
    } | ConvertTo-Json

Write-Host $Url
Write-Progress 'Submitting request' -Status '...'
$Response = Invoke-PowerBIRestMethod -Url $Url -Method Post -Body $Body
Write-Progress -Complete '(unused)'
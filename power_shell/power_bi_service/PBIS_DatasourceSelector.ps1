###########################################################
# PBIS Datasource Selector
# ---------------------------------------------------------
# Authenticate in PBIS, and select datasource
# from a specific gateway
#
# Created:  2024-10-03, filipkraus.net
# Updated:  2024-10-03, filipkraus.net
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
# Choose a gateway

Write-Host ">> Step 2: Select Gateway"
Write-Progress 'Fetching gateways' -Status '...'
$Gateways = Invoke-PowerBIRestMethod -Url "https://api.powerbi.com/v1.0/myorg/gateways" -Method Get | ConvertFrom-Json
Write-Progress -Complete '(unused)'
$Gateway = $Gateways.value `
    | Select-Object -Property id, name `
    | Out-Gridview -Title "Select Gateway" -OutputMode Single
Write-Host "Selected: $($Gateway.name) ($($Gateway.id))"

###########################################################
# Choose a datasource

Write-Host "`n>> Step 3: Select Datasource"
Write-Progress 'Fetching datasources' -Status '...'
$Datasources = Invoke-PowerBIRestMethod -Url "https://api.powerbi.com/v1.0/myorg/gateways/$($Gateway.id)/datasources" -Method Get | ConvertFrom-Json
Write-Progress -Complete '(unused)'
$Datasource = $Datasources.value `
    | Select-Object -Property id, datasourceName, datasourceType, connectionDetails, credentialType `
    | Out-Gridview -Title "Select Datasource" -OutputMode Single
Write-Host "Selected: $($Datasource.datasourceName) ($($Datasource.id))"
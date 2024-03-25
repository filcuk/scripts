# Mads Ravn, https://stackoverflow.com/a/69487355
# Call: Compare-Csv file1 file2

$ErrorActionPreference = "Stop"

function Compare-Csv
(
    [Parameter(Mandatory)] [string] $ReferenceFile,
    [Parameter(Mandatory)] [string] $DifferenceFile,
    [string[]] $ReferenceIdentifiers = $null,
    [char] $Delimiter = ';'
)
{
    $referenceData = Import-Csv -ErrorAction 'Stop' -Delimiter $Delimiter $ReferenceFile
    $differenceData = Import-Csv -ErrorAction 'Stop' -Delimiter $Delimiter $DifferenceFile
    $referenceDataHeaders = [string[]] ($referenceData | Select-Object -First 1 | Get-Member -MemberType Properties | Select-Object -ExpandProperty Name)
    $differenceDataHeaders = [string[]] ($differenceData | Select-Object -First 1 | Get-Member -MemberType Properties | Select-Object -ExpandProperty Name)
    $supersetHeaders = ($referenceDataHeaders + $differenceDataHeaders) | Select-Object -Unique

    $empty = @()
    $fileDifferences = @()
    $maxLength = ($referenceData.Length, $differenceData.Length | Measure-Object -Maximum).Maximum
    for($i = 0; $i -lt $maxLength; $i++)
    {
        $ref = $empty;
        if($i -lt $referenceData.Length)
        {
            $ref = $referenceData[$i]
        }

        $diff = $empty;
        if($i -lt $differenceData.Length)
        {
            $diff = $differenceData[$i]
        }

        $rowDifferences = $null
        foreach($header in $supersetHeaders)
        {
            $compare = Compare-Object -ReferenceObject $ref -DifferenceObject $diff -Property $header
            if($compare)
            {
                if(-not $rowDifferences)
                {
                    $rowDifferences = @{}
                    if($ReferenceIdentifiers)
                    {
                        $identifer = ($ref | Select-Object -Property $ReferenceIdentifiers).PSObject.Properties.Value
                        $rowDifferences.Add('ReferenceIdentifiers', $identifer)
                    }
                }

                $rowDifferences.Add($header, $compare)
            }
        }

        if($rowDifferences)
        {
            $fileDifferences + $rowDifferences
        }
    }

    return $fileDifferences
}

$differences = Compare-Csv -ReferenceFile 'Ref.csv' -DifferenceFile 'Diff.csv' -ReferenceIdentifiers @('ARRAY OF HEADER NAMES USED TAKEN FROM REFERENCE FILE THAT CAN BE USED TO IDENTIFY THE ROW')
foreach($difference in $differences)
{
    $out = $difference.ReferenceIdentifiers + ": " + ($difference | Select-Object -ExcludeProperty ReferenceIdentifiers | Format-List | Out-String -NoNewline)
    Write-Host ""
    Write-Host $out
}
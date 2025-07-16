
[CmdletBinding()]
param (
    [Parameter(Mandatory = $true, HelpMessage = "Name of the new Omega 365 database, for example Omega365_Demo.")]
    [string]$DatabaseName,
    [Parameter()]
    [DateTime]$SasNotBefore = (Get-Date).AddMinutes(-5),
    [Parameter()]
    [DateTime]$SasNotAfter = (Get-Date).AddDays(1),
    [Parameter()]
    [switch]$MoveFiles
)

$blobName = "Omega365_Stage_Setup.bak"
$containerName = "setup"
$storageAccountName = "om365stagebprod01"
$subcriptionId = "30499592-629c-480e-a17b-5ac742911070" # Omega 365 (MCA)

# Restoring a database from blob also requires write permission
$sasPermissions = "rwl"

$azContext = Set-AzContext -Subscription $subcriptionId -ErrorAction Stop

$stAccount = Get-AzStorageAccount | Where-Object { $_.StorageAccountName -eq $storageAccountName } -ErrorAction Stop

if ($null -eq $stAccount) {
    Write-Warning "Storage account $StorageAccountName not found. Make sure the context is correct and the account name is spelled correctly."
    exit
}

$accessKey = ($stAccount | Get-AzStorageAccountKey -ErrorAction Stop | Select-Object -First 1).Value

$storageContext = New-AzStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $accessKey -ErrorAction Stop

$sasToken = New-AzStorageBlobSASToken -Container $containerName -Blob $blobName -Permission $sasPermissions -StartTime $SasNotBefore -ExpiryTime $SasNotAfter -Context $storageContext -ErrorAction Stop

$qlScriptTemplate = @"
/***************************************
* Uses default file locations          *
****************************************/
CREATE CREDENTIAL [{CONTAINER_URL}]
WITH IDENTITY = 'SHARED ACCESS SIGNATURE', SECRET = '{SAS_TOKEN}';

RESTORE DATABASE [{DATABASE_NAME}]
FROM URL = N'{CONTAINER_URL}/{BLOB_NAME}'$(
    if ($MoveFiles) {
Write-Information "Using file locations 'F:\SQL\Data' and 'G:\SQL\Log'." -InformationAction Continue
"
WITH  FILE = 1,
MOVE N'Omega365' TO N'F:\SQL\Data\{DATABASE_NAME}.mdf',
MOVE N'Omega365_Log' TO N'G:\SQL\Log\{DATABASE_NAME}.ldf',
NOUNLOAD,  STATS = 5;"
    } else {
        ";"
    }
)

DROP CREDENTIAL [{CONTAINER_URL}];
/****************************************/
"@

$sqlScript = $qlScriptTemplate -replace "{DATABASE_NAME}", $DatabaseName -replace "{CONTAINER_URL}", "https://$storageAccountName.blob.core.windows.net/$containerName" -replace "{SAS_TOKEN}", $sasToken -replace "{BLOB_NAME}", $blobName

Write-Information "`nSQL script to restore the database from the blob:" -InformationAction Continue
Write-Information `n$sqlScript -InformationAction Continue

$sqlScript | Set-Clipboard

Write-Information "`nCopied to clipboard." -InformationAction Continue

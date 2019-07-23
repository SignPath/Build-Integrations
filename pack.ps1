Param([int]$MajorVersion = -1, [int]$MinorVersion = -1, [int]$PatchVersion = -1)

. $PSScriptRoot\_version.ps1

if($MajorVersion -eq -1) {
  $MajorVersion = $_MajorVersion
}
if($MinorVersion -eq -1) {
  $MinorVersion = $_MinorVersion
}
if($PatchVersion -eq -1) {
  $PatchVersion = $_PatchVersion
}

Write-Host "Using version $MajorVersion.$MinorVersion.$PatchVersion"

$tasks = @('signPathDownloadSignedArtifactTask', 'signPathSubmitSigningRequestTask')

# Install VstsTaskSdk module for each task
Write-Host "Installing VstsTaskSdk module..."
$modulesDirectory = ".\ps_modules\"
New-Item -ItemType Directory -Force -Path $modulesDirectory | Out-Null
Save-Module -Name VstsTaskSdk -Path $modulesDirectory

Write-Host "Copying VstsTaskSdk module to each task..."
foreach($task in $tasks) {
  $taskModulesDirectory = ".\$task\ps_modules\VstsTaskSdk\"
  New-Item -ItemType Directory -Force -Path $taskModulesDirectory | Out-Null
  Copy-Item -Force -Recurse "$($modulesDirectory)VstsTaskSdk\*\*" $taskModulesDirectory
}

# Set version for each task
Write-Host "Setting version of each task to $MajorVersion.$MinorVersion.$PatchVersion..."
foreach($task in $tasks) {
  $taskDefinitionFile = ".\$task\task.json"
  $json = Get-Content $taskDefinitionFile -raw | ConvertFrom-Json
  $json.version.Major = $MajorVersion
  $json.version.Minor = $MinorVersion
  $json.version.Patch = $PatchVersion
  $json | ConvertTo-Json -Depth 32 | Set-Content $taskDefinitionFile
}

# Set version for extension itself
Write-Host "Setting extension version to $MajorVersion.$MinorVersion.$PatchVersion..."
$extensionManifestFile = ".\vss-extension.json"
$json = Get-Content $extensionManifestFile -raw | ConvertFrom-Json
$json.version = "$MajorVersion.$MinorVersion.$PatchVersion"
$json | ConvertTo-Json -Depth 32 | Set-Content $extensionManifestFile

# Pack extension
Write-Host "Packing extension..."
tfx extension create --manifest-globs vss-extension.json

Write-Host "Done."

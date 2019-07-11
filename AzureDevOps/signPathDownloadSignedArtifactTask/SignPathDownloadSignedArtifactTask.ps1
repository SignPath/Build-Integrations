#Requires -Version 3.0

Trace-VstsEnteringInvocation $MyInvocation

try {
  Set-Location -Path $env:BUILD_SOURCESDIRECTORY

  [string]$organizationId = Get-VstsInput -Name organizationId
  [string]$signingRequestId = Get-VstsInput -Name signingRequestId
  [string]$outputArtifactPath = Get-VstsInput -Name outputArtifactPath
  [string]$ciUserToken = Get-VstsInput -Name ciUserToken
  [bool]$allowOverwriting = Get-VstsInput -Name allowOverwriting -AsBool
  [string]$apiUrl = Get-VstsInput -Name apiUrl
  
  Import-Module -Name SignPath -MinimumVersion 1.2.0 -MaximumVersion 1.2.0 -Scope Local -Force
  
  if($allowOverwriting) {
    Get-SignedArtifact `
      -ApiUrl $apiUrl `
      -CIUserToken $ciUserToken `
      -OrganizationId $organizationId `
      -SigningRequestId $signingRequestId `
      -OutputArtifactPath $outputArtifactPath `
      -Force
  } else {
    Get-SignedArtifact `
      -ApiUrl $apiUrl `
      -CIUserToken $ciUserToken `
      -OrganizationId $organizationId `
      -SigningRequestId $signingRequestId `
      -OutputArtifactPath $outputArtifactPath
  }
} finally {
    Trace-VstsLeavingInvocation $MyInvocation
}
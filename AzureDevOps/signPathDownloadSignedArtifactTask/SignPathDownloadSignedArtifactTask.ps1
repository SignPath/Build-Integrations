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
  [string]$waitForCompletionTimeoutInSeconds = Get-VstsInput -Name waitForCompletionTimeoutInSeconds
  
  Install-Module -Name SignPath -MinimumVersion 1.2.0 -MaximumVersion 1.2.0 -Scope CurrentUser -Force
  
  if($allowOverwriting) {
    Get-SignedArtifact `
      -ApiUrl $apiUrl `
      -CIUserToken $ciUserToken `
      -OrganizationId $organizationId `
      -SigningRequestId $signingRequestId `
      -OutputArtifactPath $outputArtifactPath `
      -WaitForCompletionTimeoutInSeconds $waitForCompletionTimeoutInSeconds `
      -Force
  } else {
    Get-SignedArtifact `
      -ApiUrl $apiUrl `
      -CIUserToken $ciUserToken `
      -OrganizationId $organizationId `
      -SigningRequestId $signingRequestId `
      -OutputArtifactPath $outputArtifactPath `
      -WaitForCompletionTimeoutInSeconds $waitForCompletionTimeoutInSeconds
  }
} finally {
    Trace-VstsLeavingInvocation $MyInvocation
}
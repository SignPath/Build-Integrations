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
  
  # Install the highest minor/patch version of the module
  Install-Module -Name SignPath -MinimumVersion 2.0.0 -MaximumVersion 2.999.999 -Scope CurrentUser -Force
  
  $arguments = @{}
  $arguments["ApiUrl"] = $apiUrl
  $arguments["CIUserToken"] = $ciUserToken
  $arguments["OrganizationId"] = $organizationId
  $arguments["SigningRequestId"] = $signingRequestId
  $arguments["OutputArtifactPath"] = $outputArtifactPath
  $arguments["WaitForCompletionTimeoutInSeconds"] = $waitForCompletionTimeoutInSeconds
  if($allowOverwriting) {
    $arguments["Force"] = $True
  }

  Get-SignedArtifact @arguments

} finally {
    Trace-VstsLeavingInvocation $MyInvocation
}
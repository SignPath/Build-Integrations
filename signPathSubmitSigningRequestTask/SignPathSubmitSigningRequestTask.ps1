#Requires -Version 3.0

Trace-VstsEnteringInvocation $MyInvocation

try {
  Set-Location -Path $env:BUILD_SOURCESDIRECTORY

  [string]$waitForCompletion = Get-VstsInput -Name waitForCompletion
  [string]$inputArtifactPath = Get-VstsInput -Name inputArtifactPath
  [string]$organizationId = Get-VstsInput -Name organizationId
  [string]$projectSlug = Get-VstsInput -Name projectSlug
  [string]$signingPolicySlug = Get-VstsInput -Name signingPolicySlug
  [string]$artifactConfigurationSlug = Get-VstsInput -Name artifactConfigurationSlug
  [string]$ciUserToken = Get-VstsInput -Name ciUserToken
  [string]$inputArtifactDescription = Get-VstsInput -Name inputArtifactDescription
  [string]$apiUrl = Get-VstsInput -Name apiUrl
  [string]$waitForCompletionTimeoutInSeconds = Get-VstsInput -Name waitForCompletionTimeoutInSeconds

  # Install the highest minor/patch version of the module
  Install-Module -Name SignPath -MinimumVersion 2.0.0 -MaximumVersion 2.999.999 -Scope CurrentUser -Force
  
  $inputArtifactPath = Find-VstsMatch -Pattern $inputArtifactPath
  
  $arguments = @{}
  $arguments["ApiUrl"] = $apiUrl
  $arguments["CIUserToken"] = $ciUserToken
  $arguments["OrganizationId"] = $organizationId
  $arguments["ProjectSlug"] = $projectSlug
  $arguments["ArtifactConfigurationSlug"] = $artifactConfigurationSlug
  $arguments["SigningPolicySlug"] = $signingPolicySlug
  $arguments["InputArtifactPath"] = $inputArtifactPath
  $arguments["Description"] = $inputArtifactDescription
  
  if($waitForCompletion -eq 'sync') {
    [string]$outputArtifactPath = Get-VstsInput -Name outputArtifactPath
    [bool]$allowOverwriting = Get-VstsInput -Name allowOverwriting -AsBool
    
    $arguments["WaitForCompletion"] = $True
    $arguments["WaitForCompletionTimeoutInSeconds"] = $waitForCompletionTimeoutInSeconds
    $arguments["OutputArtifactPath"] = $outputArtifactPath
    if($allowOverwriting) {
      $arguments["Force"] = $True
    }
  }
  
  $signingRequestId = Submit-SigningRequest @arguments
  
  if($waitForCompletion -eq 'async') {
    [string]$outputVariableName = Get-VstsInput -Name outputVariableName
    
    if($outputVariableName) {
      Write-VstsSetVariable -Name $outputVariableName -Value $signingRequestId
    }
    
    Write-Host "Signing request ID: $signingRequestId"
  }

} finally {
    Trace-VstsLeavingInvocation $MyInvocation
}
#Requires -Version 3.0

Trace-VstsEnteringInvocation $MyInvocation

try {
  Set-Location -Path $env:BUILD_SOURCESDIRECTORY

  [string]$waitForCompletion = Get-VstsInput -Name waitForCompletion
  [string]$inputArtifactPath = Get-VstsInput -Name inputArtifactPath
  [string]$organizationId = Get-VstsInput -Name organizationId
  [string]$projectName = Get-VstsInput -Name projectName
  [string]$signingPolicyName = Get-VstsInput -Name signingPolicyName
  [string]$artifactConfigurationName = Get-VstsInput -Name artifactConfigurationName
  [string]$ciUserToken = Get-VstsInput -Name ciUserToken
  [string]$inputArtifactDescription = Get-VstsInput -Name inputArtifactDescription
  [string]$apiUrl = Get-VstsInput -Name apiUrl
  
  Install-Module -Name SignPath -MinimumVersion 1.2.0 -MaximumVersion 1.2.0 -Scope CurrentUser -Force
  
  $inputArtifactPath = Find-VstsMatch -Pattern $inputArtifactPath
  
  if($waitForCompletion -eq 'sync') {
    [string]$outputArtifactPath = Get-VstsInput -Name outputArtifactPath
    [bool]$allowOverwriting = Get-VstsInput -Name allowOverwriting -AsBool
    
    if($allowOverwriting) {
      Submit-SigningRequest `
        -ApiUrl $apiUrl `
        -CIUserToken $ciUserToken `
        -OrganizationId $organizationId `
        -ProjectName $projectName `
        -ArtifactConfigurationName $artifactConfigurationName `
        -SigningPolicyName $signingPolicyName `
        -InputArtifactPath $inputArtifactPath `
        -Description $inputArtifactDescription `
        -WaitForCompletion `
        -OutputArtifactPath $outputArtifactPath `
        -Force
    } else {
      Submit-SigningRequest `
        -ApiUrl $apiUrl `
        -CIUserToken $ciUserToken `
        -OrganizationId $organizationId `
        -ProjectName $projectName `
        -ArtifactConfigurationName $artifactConfigurationName `
        -SigningPolicyName $signingPolicyName `
        -InputArtifactPath $inputArtifactPath `
        -Description $inputArtifactDescription `
        -WaitForCompletion `
        -OutputArtifactPath $outputArtifactPath
    }
  } else {
    [string]$outputVariableName = Get-VstsInput -Name outputVariableName
  
    $signingRequestId = Submit-SigningRequest `
      -ApiUrl $apiUrl `
      -CIUserToken $ciUserToken `
      -OrganizationId $organizationId `
      -ProjectName $projectName `
      -ArtifactConfigurationName $artifactConfigurationName `
      -SigningPolicyName $signingPolicyName `
      -InputArtifactPath $inputArtifactPath `
      -Description $inputArtifactDescription

    if($outputVariableName) {
      Write-VstsSetVariable -Name $outputVariableName -Value $signingRequestId
    }
    
    Write-Host "Signing request ID: $signingRequestId"
  }
} finally {
    Trace-VstsLeavingInvocation $MyInvocation
}
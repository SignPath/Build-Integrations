[![SignPath logo](./images/logo_signpath_500.png)](https://about.signpath.io)

# SignPath Azure DevOps Build Pipeline Tasks

This repository contains the Azure DevOps Build Pipeline tasks for [SignPath.io](https://about.signpath.io) that can be used to integrate code signing into your build pipeline. You can find the tasks on the [Azure DevOps marketplace](https://marketplace.visualstudio.com/items?itemName=SignPath.signpath-tasks). 

## Available tasks

* **SignPathSubmitSigningRequestTask**  
 Submit an artifact to SignPath. Either wait for the artifact to be signed synchronously and immediately download the resulting artifact, or, choose to write the signing request ID into an output variable and download the signed artifact later on using the SignPathDownloadSignedArtifact task.
* **SignPathDownloadSignedArtifactTask**  
 Download a signed artifact from SignPath. This task waits if the signing request has not yet been completed.

## Status
[![Build Status](https://dev.azure.com/signpath/SignPath.Integrations.AzureDevOps/_apis/build/status/SignPath.Integrations.AzureDevOps?branchName=master)](https://dev.azure.com/signpath/SignPath.Integrations.AzureDevOps/_build/latest?definitionId=1&branchName=master)

The project is built using [Azure DevOps pipelines](https://dev.azure.com/signpath/SignPath.Integrations.AzureDevOps) and the very same tasks provided in this repository for code signing. You can view the [azure-pipelines.yml](./azure-pipelines.yml) for reference.
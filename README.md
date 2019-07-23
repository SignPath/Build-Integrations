# SignPath Azure DevOps Build Pipeline Tasks

Build tasks to integrate SignPath code signing into your build pipeline.

## Installation

Go to the [Azure DevOps marketplace](https://marketplace.visualstudio.com/items?itemName=SignPath.signpath-tasks) to install the SignPath extension into your Azure DevOps organization. Afterwards you can find the SignPath tasks in your task list when creating or updating a build pipeline.

## Available tasks

### SignPathSubmitSigningRequestTask

Submit an artifact to SignPath. Either wait for the artifact to be signed synchronously and immediately download the resulting artifact, or, choose to write the signing request ID into an output variable and download the signed artifact later on using the SignPathDownloadSignedArtifact task.

### SignPathDownloadSignedArtifactTask

Download a signed artifact from SignPath. This task waits if the signing request has not yet been completed.

# SignPath Azure DevOps Build Pipeline Tasks

Build tasks to integrate SignPath code signing into your build pipeline.

## SignPathSubmitSigningRequestTask

Submit an artifact to SignPath. Either wait for the artifact to be signed synchronously and immediately download the resulting artifact, or, choose to write the signing request ID into an output variable and download the signed artifact later on using the SignPathDownloadSignedArtifact task.

## SignPathDownloadSignedArtifactTask

Download a signed artifact from SignPath. This tasks waits if the signing request has not yet been completed.

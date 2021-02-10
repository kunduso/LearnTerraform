## Introduction
In this module I am using Microsoft Azure DevOps as the orchestrator to provision resource (an S3 bucket) in AWS. I am storing the state file in a separate S3 bucket.
</br>The credentials are stored as secret variables in Azure DevOps pipeline and passed to terraform via the commandline.
## Introduction
In this module I am using Microsoft Azure DevOps as the orchestrator to provision a resource (an S3 bucket) in AWS. I am storing the state file in a separate S3 bucket.

The credentials are stored as secret variables in the Azure DevOps pipeline and passed to Terraform via the command line.

This is the companion code for the blog post [Azure DevOps and Terraform to provision AWS S3](https://skundunotes.com/2021/02/14/azure-devops-and-terraform-to-provision-aws-s3/).

## What it creates
An Amazon S3 bucket, with Terraform state stored remotely in a separate S3 bucket (see `backend.tf`).

## How it works
The pipeline is defined in [`azure-pipelines.yml`](../azure-pipelines.yml) at the repository root. It installs Terraform, then runs the Terraform workflow against this folder (`init`, with `plan`/`apply` tasks) using the AWS provider and an S3 backend. AWS credentials (`access_key` / `secret_key`) are held as secret pipeline variables in Azure DevOps and passed to Terraform via the command line at runtime, so they are not stored in this repository.

> This example passes long-lived AWS credentials as pipeline secrets. For a keyless approach on GitHub Actions, see [`add-github-oidc-role`](../add-github-oidc-role/ReadMe.md), which uses OpenID Connect instead of static keys.

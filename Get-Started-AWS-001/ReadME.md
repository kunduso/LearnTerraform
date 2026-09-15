## Motivation
I learnt about AWS IAM user and how to create them on AWS portal. My intention was to be able to provision an S3 bucket in AWS with Terraform using the credentials of the IAM user.

## What it creates
An Amazon S3 bucket (with a random numeric suffix for a unique name), using the AWS provider v3 and authenticated with an IAM user's static access and secret keys passed as variables.

## Usage
```bash
terraform init
terraform plan
terraform apply
```
Provide values for `region`, `access_key`, and `secret_key` (for example, through a `.tfvars` file or environment variables). `bucket_name` defaults to `terraform-bucket`. Do not commit credentials to version control.

> This is an early learning example. It uses long-lived IAM user keys for authentication; see [`add-github-oidc-role`](../add-github-oidc-role/ReadMe.md) for the OpenID Connect approach that avoids static keys.

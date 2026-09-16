## Motivation
I learnt about Terraform variables and am using the `count` construct here to create multiple S3 buckets in AWS using `count` and `count.index`.

## What it creates
- Three Amazon S3 buckets, created with `count = 3` and named from a list variable indexed by `count.index` (each with a random numeric suffix for uniqueness).
- An EC2 instance (`t2.micro`) whose AMI is selected from a map variable keyed by region.
- A security group allowing inbound RDP (port 3389).

## Usage
```bash
terraform init
terraform plan -out variables.tfplan
terraform apply "variables.tfplan"
```
Provide values for `access_key` and `secret_key` (for example, through a `.tfvars` file or environment variables). `region`, `bucket_name` (a list), and `ami_location` (a map) are defined in `variable.tf`. Do not commit credentials to version control.

When finished, clean up with:
```bash
terraform destroy
```

> **Security note:** The security group opens RDP (port 3389) to `0.0.0.0/0`, which allows access from any IP address. This is convenient for learning but unsafe for real use — restrict the CIDR range to known addresses.
>
> This is an early learning example that authenticates with long-lived IAM user keys; see [`add-github-oidc-role`](../add-github-oidc-role/ReadMe.md) for the OpenID Connect approach that avoids static keys.

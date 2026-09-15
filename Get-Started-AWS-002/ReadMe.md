## Motivation
Building on provisioning a single resource, this example creates Amazon EC2 instances behind a security group and introduces storing Terraform state remotely in Amazon S3.

## What it creates
- Two Amazon EC2 instances (`t2.micro`) from a specified AMI, using the `count` construct (`instance_count` defaults to 2).
- A security group allowing inbound RDP (port 3389).
- Optionally, an S3 remote-state backend (see `backend.tf.example`).

## Usage
```bash
terraform init
terraform plan
terraform apply
```
Provide values for `aws_access_key` and `aws_secret_key` (for example, through a `.tfvars` file or environment variables). `region`, `ami`, and `instance_count` have defaults in `variables.tf`. Do not commit credentials to version control.

To use remote state, copy `backend.tf.example` to `backend.tf`, update the `bucket`/`key`/`region` values to a bucket you own, and re-run `terraform init`.

> **Security note:** The security group opens RDP (port 3389) to `0.0.0.0/0`, which allows access from any IP address. This is convenient for learning but unsafe for real use — restrict the CIDR range to known addresses.
>
> This is an early learning example that authenticates with long-lived IAM user keys; see [`add-github-oidc-role`](../add-github-oidc-role/ReadMe.md) for the OpenID Connect approach that avoids static keys.

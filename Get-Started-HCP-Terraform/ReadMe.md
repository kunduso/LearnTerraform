# Get Started with HCP Terraform

This folder shows how to provision AWS networking through **HCP Terraform** (HashiCorp Cloud Platform), HashiCorp's managed service for running Terraform with remote state and remote execution.

It is the companion code for the blog post [Provision AWS Resources with GitHub and HCP Terraform](https://skundunotes.com/2025/01/03/provision-aws-resources-with-github-and-hcp-terraform/).

## What it does

Consumes a reusable, versioned VPC module to build a network:

- Sources the module from [`kunduso/terraform-aws-vpc`](https://github.com/kunduso/terraform-aws-vpc) pinned at tag `v1.0.2`
- Creates a VPC with an internet gateway
- Provisions three public and three private subnets

## Files

| File | Purpose |
|------|---------|
| `network.tf` | Calls the VPC module with CIDR and subnet inputs |
| `provider.tf` | AWS provider and HCP Terraform (cloud) configuration |
| `variable.tf` | Input variables |

## Usage

With HCP Terraform, `plan` and `apply` execute remotely in your configured workspace rather than on your machine:

```bash
terraform login    # authenticate to HCP Terraform
terraform init     # connects to the remote workspace (organization "kunduso", workspace "app-two-layer-0")
terraform plan
terraform apply
```

Provide values for `region`, `access_key`, and `secret_key` (the AWS credentials used by the provider), typically as workspace variables in HCP Terraform. Do not commit credentials to version control.

> The module source is pinned to a release tag rather than a commit hash; the corresponding Checkov check (`CKV_TF_1`) is intentionally skipped for this self-hosted module.

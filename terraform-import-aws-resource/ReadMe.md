# Import existing AWS resources into Terraform

This folder demonstrates how to bring **already-existing AWS resources under Terraform management** using Terraform `import` blocks (Terraform 1.5+), so you can manage manually-created infrastructure as code without recreating it.

It is the companion code for the blog post [Automate AWS resource import into Terraform state using GitHub Actions](https://skundunotes.com/2025/11/03/automate-aws-resource-import-into-terraform-state-using-github-actions/), which walks through the full workflow step by step.

## What it does

Uses declarative [`import` blocks](https://developer.hashicorp.com/terraform/language/import) to adopt an existing web-tier network into Terraform state:

- A VPC (`aws_vpc.imported_vpc`)
- Public and private subnets across two Availability Zones
- Route tables and their subnet associations

Each `import` block pairs a target resource address with the real AWS resource ID. On the next `terraform plan`/`apply`, Terraform reads those resources into state and reconciles them with the written configuration, rather than creating new ones.

## Files

| File | Purpose |
|------|---------|
| `main.tf` | Import blocks and matching resource definitions for the VPC, subnets, route tables, and associations |
| `provider.tf` | AWS provider and Terraform settings |
| `backend.tf` | Remote state backend configuration |
| `variables.tf` | Input variables |

## CI/CD

This folder is wired to the [`terraform-import.yml`](../.github/workflows/terraform-import.yml) GitHub Actions workflow, which runs `init`/`validate`/`plan` on pull requests and `apply` on merge to `main`, authenticating to AWS via OIDC.

## Usage

```bash
terraform init
terraform plan     # confirm resources are imported (not recreated)
terraform apply
```

> Before applying, review the plan carefully and confirm the resources show as **imported**, not **created**. The resource IDs in the `import` blocks are specific to the account they were captured from; update them for your environment.

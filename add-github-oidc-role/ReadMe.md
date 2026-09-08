# GitHub Actions OIDC role for AWS

This Terraform configuration creates a GitHub Actions OpenID Connect (OIDC) identity
provider and an IAM role that `kunduso/LearnTerraform` GitHub Actions workflows can assume —
without storing long-lived AWS access keys as repository secrets.

It is the Infrastructure as Code version of the manual, console-based walkthrough in
[Securely integrate AWS Credentials with GitHub Actions using OpenID Connect](https://skundunotes.com/2023/02/28/securely-integrate-aws-credentials-with-github-actions-using-openid-connect/).

## What it creates

- An IAM OIDC identity provider for `token.actions.githubusercontent.com` (one per account).
- An IAM role whose trust policy allows GitHub Actions from the configured repository to call
  `sts:AssumeRoleWithWebIdentity`.
- An attached managed policy (defaults to `AdministratorAccess` — see the note below).

## Trust policy: immutable ID matching

The trust policy conditions on the `sub` claim (required by AWS — a GitHub OIDC trust policy
must be scoped by `sub` or `job_workflow_ref`) **and** additionally on the immutable numeric
claims `repository_id` and `repository_owner_id` for defense in depth.

GitHub introduced immutable subject claims for OIDC tokens on **July 15, 2026**. Repositories
created, renamed, or transferred after that date embed numeric owner and repository IDs in the
`sub` (for example `repo:owner@123456789/repo@987654321:*`), while older repositories keep the
name-only format (`repo:owner/repo:*`). Matching on the numeric ID claims:

- works for both the old and new `sub` formats, and
- survives repository renames and transfers (the IDs never change).

`kunduso/LearnTerraform` was created in 2020, so it still emits the name-only `sub` today —
but matching on IDs is forward-compatible regardless.

Find the IDs for any repository with the GitHub CLI:

```bash
gh api repos/<owner>/<repo> --jq '{repo_id: .id, owner_id: .owner.id}'
```

Set them via the `github_repository_id` and `github_repository_owner_id` variables.

> **Note:** This trust policy allows any branch, environment, or workflow in the repository to
> assume the role (it does not restrict by `ref`). To limit to a specific branch, add a
> condition on the `sub` claim.

## Prerequisites

- Terraform >= 1.11.
- AWS credentials for the target account with permission to create IAM providers and roles
  (apply this manually — it is not run through CI, since it bootstraps the role CI will use).
- The S3 state bucket referenced in `provider.tf` must already exist.

## Usage

```bash
terraform init
terraform plan
terraform apply
```

After apply, use the `role_arn` output as `role-to-assume` in `aws-actions/configure-aws-credentials`,
typically stored as a GitHub Actions secret.

## Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `region` | `us-east-2` | AWS region. |
| `role_name` | `github-actions-oidc-role` | Name of the IAM role. |
| `github_repository` | `kunduso/LearnTerraform` | Repository (for readability/tagging). |
| `github_repository_id` | `287926743` | Immutable repository ID used in the trust condition. |
| `github_repository_owner_id` | `35611714` | Immutable owner ID used in the trust condition. |
| `managed_policy_arn` | `AdministratorAccess` | Managed policy attached to the role. |

## Least privilege note

The role defaults to `AdministratorAccess` for convenience. This does **not** follow the
principle of least privilege. For real use, replace `managed_policy_arn` with a policy scoped to
only what your workflows need.

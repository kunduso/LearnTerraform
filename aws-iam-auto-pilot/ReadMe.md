# Scope Terraform apply permissions with IAM Policy Autopilot

This folder demonstrates how to scope the IAM permissions of a Terraform provisioning pipeline to **exactly what each change needs**, using [IAM Policy Autopilot](https://github.com/awslabs/iam-policy-autopilot) to generate an IAM policy from the Terraform plan and applying it to a dedicated apply role for the duration of each deployment.

## The problem

The IAM role that runs `terraform apply` tends to accumulate broad permissions — often `AdministratorAccess` — because hand-maintaining a least-privilege policy for every resource change does not scale. If those credentials leak, the blast radius is the whole account.

## The approach

Two roles with separated duties:

| Role | Assumed by | Permissions |
|------|-----------|-------------|
| **Pipeline role** (`autopilot-pipeline-role`) | GitHub Actions via OIDC | Read-only for `terraform plan`, S3 state access, and `PutRolePolicy`/`DeleteRolePolicy` scoped to the apply role only. Cannot modify itself. |
| **Apply role** (`autopilot-apply-role`) | The pipeline role (role chaining) | Static S3 statefile access only; receives the plan-scoped policy at runtime. |

On each change, the pipeline generates a policy from the plan, attaches it to the apply role, runs `terraform apply` as that role, then removes the policy — so the apply role never holds standing permissions beyond state access.

## Folder layout

| Path | What it is |
|------|-----------|
| [`iam-roles/`](iam-roles/) | Bootstrap stack that creates the pipeline and apply roles. Applied **manually** with admin credentials (it bootstraps the roles CI uses; it is not run through the pipeline). |
| [`infra/`](infra/) | The workload Terraform (a demo VPC) that the pipeline provisions. |
| `generated-policy/` | Holds `generated-policy.json`, the scoped policy generated from the plan and committed on the PR for review. |

## Workflows

| Workflow | Trigger | What it does |
|----------|---------|--------------|
| [`terraform-iam-autopilot.yml`](../.github/workflows/terraform-iam-autopilot.yml) | push / PR / merge to `main` | **PR:** plan → generate scoped policy → commit it to the branch and post it as a review comment. **Merge:** attach the reviewed policy to the apply role → assume the apply role → `terraform apply` → always remove the policy. |
| [`terraform-iam-autopilot-deny.yml`](../.github/workflows/terraform-iam-autopilot-deny.yml) | manual (`workflow_dispatch`) | Attaches the policy to the apply role, assumes it, and confirms an out-of-scope call (`aws ec2 describe-instances`) is denied — proving the guardrail. Always cleans up afterward. |

## Setup

1. Ensure a GitHub Actions OIDC provider exists in the account (see [`../add-github-oidc-role`](../add-github-oidc-role)).
2. Apply `iam-roles/` manually with admin credentials to create the two roles.
3. Store the role ARNs as GitHub Actions secrets: `AUTOPILOT_PIPELINE_ROLE_ARN`, `AUTOPILOT_APPLY_ROLE_ARN`.
4. Open a PR that changes `infra/` — review the generated policy, then merge to apply under scoped credentials.

## Notes

- IAM Policy Autopilot generates **identity-based policies only** (no resource-based policies, SCPs, or permissions boundaries). Treat the output as a reviewed baseline.
- State-backend actions are **not** in the generated policy (they are not part of the plan), so the apply role carries a static state-access policy.
- Branch protection on `main` requiring a reviewed PR is what actually gates changes; the committed policy is the reviewed artifact.

data "aws_caller_identity" "current" {}

# The GitHub Actions OIDC provider must already exist in this account
# (one provider per account for this URL). Look it up rather than create it.
data "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
}

locals {
  apply_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.apply_role_name}"

  state_bucket_arn = "arn:aws:s3:::${var.state_bucket}"

  # The exact infra state object and its S3 native lock file. Scoping object
  # permissions to these specific keys — rather than a prefix wildcard — keeps
  # the roles from reading or writing any other object in the state bucket.
  infra_state_key = "${var.state_key_prefix}/infra/terraform.tfstate"
  state_object_arns = [
    "arn:aws:s3:::${var.state_bucket}/${local.infra_state_key}",
    "arn:aws:s3:::${var.state_bucket}/${local.infra_state_key}.tflock",
  ]
}

# ---------------------------------------------------------------------------
# Pipeline role — assumed by GitHub Actions via OIDC.
# Runs terraform plan (reads), accesses the infra state, and manages the apply
# role's inline policy. It cannot modify its own permissions.
# ---------------------------------------------------------------------------
data "aws_iam_policy_document" "pipeline_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    # AWS requires the trust to be scoped by :sub; the ID conditions cannot stand alone.
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_repository}:*"]
    }

    # Additional tightening on immutable IDs so the trust survives repository
    # renames/transfers and works with GitHub's immutable subject claims.
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:repository_owner_id"
      values   = [var.github_repository_owner_id]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:repository_id"
      values   = [var.github_repository_id]
    }
  }
}

resource "aws_iam_role" "pipeline" {
  name               = var.pipeline_role_name
  description        = "Assumed by GitHub Actions via OIDC. Runs terraform plan, manages the apply role's policy, and assumes the apply role."
  assume_role_policy = data.aws_iam_policy_document.pipeline_trust.json

  tags = {
    Name = var.pipeline_role_name
  }
}

# Pipeline role's inline policy: the read actions terraform plan needs, state
# access, managing the apply role's inline policy, and assuming the apply role.
# Instead of the broad AWS-managed ReadOnlyAccess policy, plan-time reads are
# scoped to only the EC2 Describe actions the VPC in infra/ requires.
#
# NOTE: this couples the pipeline role to the resource types in the Terraform
# configuration. If infra/ adds resources of other types, extend the
# TerraformPlanReads statement with the matching Describe/List actions (see the
# IAM service authorization reference for each resource's read actions).
data "aws_iam_policy_document" "pipeline_permissions" {
  statement {
    sid    = "TerraformPlanReads"
    effect = "Allow"
    # These EC2 Describe actions do not support resource-level permissions, so
    # the Resource element must be "*". They are read-only and enumerate VPCs,
    # their attributes/tags, and the default network resources the AWS provider
    # refreshes when planning an aws_vpc. The aws:RequestedRegion condition
    # restricts them to the deployment region. (An account condition is not
    # added: these Describe calls are inherently limited to the caller's own
    # account, so there is nothing further to scope.)
    actions = [
      "ec2:DescribeVpcs",
      "ec2:DescribeVpcAttribute",
      "ec2:DescribeTags",
      "ec2:DescribeNetworkAcls",
      "ec2:DescribeRouteTables",
      "ec2:DescribeSecurityGroups"
    ]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestedRegion"
      values   = [var.region]
    }
  }
  statement {
    sid       = "TerraformStateBucketAccess"
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = [local.state_bucket_arn]
  }
  statement {
    sid       = "TerraformStateFileAccess"
    effect    = "Allow"
    actions   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = local.state_object_arns
  }
  statement {
    sid       = "ManageApplyRolePolicy"
    effect    = "Allow"
    actions   = ["iam:PutRolePolicy", "iam:DeleteRolePolicy", "iam:GetRolePolicy"]
    resources = [local.apply_role_arn]
  }
  statement {
    sid       = "AssumeApplyRole"
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    resources = [local.apply_role_arn]
  }
}

resource "aws_iam_role_policy" "pipeline_permissions" {
  # checkov:skip=CKV_AWS_356: The EC2 Describe* actions terraform plan requires do not
  # support resource-level permissions, so Resource must be "*". They are read-only.
  name   = "pipeline-permissions"
  role   = aws_iam_role.pipeline.id
  policy = data.aws_iam_policy_document.pipeline_permissions.json
}

# ---------------------------------------------------------------------------
# Apply role — assumed by the pipeline role (role chaining), not by OIDC.
# Has static state access; the plan-scoped policy is attached at runtime by the
# pipeline and removed after apply.
# ---------------------------------------------------------------------------
data "aws_iam_policy_document" "apply_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.pipeline.arn]
    }
  }
}

resource "aws_iam_role" "apply" {
  name               = var.apply_role_name
  description        = "Assumed by the pipeline role to run terraform apply, scoped by a policy generated from the plan."
  assume_role_policy = data.aws_iam_policy_document.apply_trust.json

  tags = {
    Name = var.apply_role_name
  }
}

# Static state access on the apply role. The generated policy (attached at
# runtime) covers only the resources in the plan and does NOT include state
# actions, so state access must live here.
data "aws_iam_policy_document" "apply_state_access" {
  statement {
    sid       = "TerraformStateBucketAccess"
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = [local.state_bucket_arn]
  }
  statement {
    sid       = "TerraformStateFileAccess"
    effect    = "Allow"
    actions   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = local.state_object_arns
  }
}

resource "aws_iam_role_policy" "apply_state_access" {
  name   = "terraform-state-access"
  role   = aws_iam_role.apply.id
  policy = data.aws_iam_policy_document.apply_state_access.json
}

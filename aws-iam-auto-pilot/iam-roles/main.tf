data "aws_caller_identity" "current" {}

# The GitHub Actions OIDC provider already exists in this account
# (created by add-github-oidc-role). One provider per account for this URL,
# so we look it up rather than create a duplicate.
data "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
}

locals {
  apply_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.apply_role_name}"

  # State access: the infra state object and lock, plus ListBucket on the bucket.
  state_bucket_arn = "arn:aws:s3:::${var.state_bucket}"
  state_object_arn = "arn:aws:s3:::${var.state_bucket}/${var.state_key_prefix}/*"
}

# ---------------------------------------------------------------------------
# Pipeline role — assumed by GitHub Actions via OIDC.
# It runs terraform plan (reads), accesses the infra state, and manages the
# apply role's inline policy. It cannot modify its own permissions.
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

# Read-only across AWS so terraform plan can refresh state.
resource "aws_iam_role_policy_attachment" "pipeline_readonly" {
  role       = aws_iam_role.pipeline.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# Pipeline role's own inline policy: state access, manage the apply role's
# inline policy, and assume the apply role. Scoped to the apply role ARN only,
# so the pipeline role cannot alter its own permissions.
data "aws_iam_policy_document" "pipeline_permissions" {
  statement {
    sid    = "TerraformStateAccess"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket",
    ]
    resources = [local.state_bucket_arn, local.state_object_arn]
  }

  statement {
    sid    = "ManageApplyRolePolicy"
    effect = "Allow"
    actions = [
      "iam:PutRolePolicy",
      "iam:DeleteRolePolicy",
      "iam:GetRolePolicy",
    ]
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
  name   = "pipeline-permissions"
  role   = aws_iam_role.pipeline.id
  policy = data.aws_iam_policy_document.pipeline_permissions.json
}

# ---------------------------------------------------------------------------
# Apply role — assumed by the pipeline role (role chaining), not by OIDC.
# It has static state access; the plan-scoped policy is attached at runtime
# by the pipeline and removed after apply.
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
    sid    = "TerraformStateAccess"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket",
    ]
    resources = [local.state_bucket_arn, local.state_object_arn]
  }
}

resource "aws_iam_role_policy" "apply_state_access" {
  name   = "terraform-state-access"
  role   = aws_iam_role.apply.id
  policy = data.aws_iam_policy_document.apply_state_access.json
}
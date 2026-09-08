data "aws_caller_identity" "current" {}

# GitHub Actions OIDC identity provider (one per account for this URL).
resource "aws_iam_openid_connect_provider" "github" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
  # GitHub's OIDC thumbprint. AWS no longer relies on this value for
  # token.actions.githubusercontent.com, but the argument is still required.
  thumbprint_list = ["ffffffffffffffffffffffffffffffffffffffff"]

  tags = {
    Name = "github-actions-oidc"
  }
}

# Trust policy: allow the GitHub repository to assume this role via OIDC.
#
# We match on the immutable numeric claims repository_id and repository_owner_id
# rather than the sub claim. GitHub introduced immutable subject claims on
# July 15, 2026: repositories created (or renamed/transferred) after that date
# embed numeric owner/repo IDs in the sub (e.g. repo:owner@ID/repo@ID:*), while
# older repositories keep the name-only sub (repo:owner/repo:*). Matching on the
# numeric ID claims works for both eras and survives repository renames and
# transfers. See https://skundunotes.com/2023/02/28/securely-integrate-aws-credentials-with-github-actions-using-openid-connect/
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    # AWS requires the trust policy to be scoped by :sub (or :job_workflow_ref);
    # the numeric ID conditions below cannot stand alone.
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

resource "aws_iam_role" "github_actions" {
  name               = var.role_name
  description        = "Assumed by GitHub Actions via OIDC to interact with this AWS account."
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = {
    Name = var.role_name
  }
}

resource "aws_iam_role_policy_attachment" "github_actions" {
  role       = aws_iam_role.github_actions.name
  policy_arn = var.managed_policy_arn
}

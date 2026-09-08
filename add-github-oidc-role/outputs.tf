output "role_arn" {
  description = "ARN of the GitHub Actions OIDC role. Use this as the role-to-assume in configure-aws-credentials."
  value       = aws_iam_role.github_actions.arn
}

output "oidc_provider_arn" {
  description = "ARN of the GitHub Actions OIDC identity provider."
  value       = aws_iam_openid_connect_provider.github.arn
}

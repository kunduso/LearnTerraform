output "pipeline_role_arn" {
  description = "ARN of the pipeline role. Store as the AUTOPILOT_PIPELINE_ROLE_ARN GitHub Actions secret."
  value       = aws_iam_role.pipeline.arn
}

output "apply_role_arn" {
  description = "ARN of the apply role. Store as the AUTOPILOT_APPLY_ROLE_ARN GitHub Actions secret."
  value       = aws_iam_role.apply.arn
}

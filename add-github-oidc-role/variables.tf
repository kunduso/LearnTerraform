variable "region" {
  description = "AWS region."
  type        = string
  default     = "us-east-2"
}

variable "role_name" {
  description = "Name of the IAM role that GitHub Actions assumes via OIDC."
  type        = string
  default     = "github-actions-oidc-role"
}

variable "github_repository" {
  description = "GitHub repository (owner/repo) allowed to assume the role, for readability and tagging."
  type        = string
  default     = "kunduso/LearnTerraform"
}

variable "github_repository_id" {
  description = "Immutable numeric GitHub repository ID. Used in the OIDC trust condition so it survives repository renames/transfers and works with GitHub's immutable subject claims (July 15, 2026 change). Find it with: gh api repos/<owner>/<repo> --jq .id"
  type        = string
  default     = "287926743" # kunduso/LearnTerraform
}

variable "github_repository_owner_id" {
  description = "Immutable numeric GitHub owner ID. Find it with: gh api repos/<owner>/<repo> --jq .owner.id"
  type        = string
  default     = "35611714" # kunduso
}

variable "managed_policy_arn" {
  description = "Managed policy attached to the role. Defaults to AdministratorAccess (broad; scope down for production)."
  type        = string
  default     = "arn:aws:iam::aws:policy/AdministratorAccess"
}

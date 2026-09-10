variable "region" {
  description = "AWS region."
  type        = string
  default     = "us-west-2"
}

variable "github_repository" {
  description = "GitHub repository (owner/repo) allowed to assume the pipeline role via OIDC."
  type        = string
  default     = "kunduso/LearnTerraform"
}

variable "github_repository_id" {
  description = "Immutable numeric GitHub repository ID used in the OIDC trust condition. Find it with: gh api repos/<owner>/<repo> --jq .id"
  type        = string
  default     = "287926743" # kunduso/LearnTerraform
}

variable "github_repository_owner_id" {
  description = "Immutable numeric GitHub owner ID used in the OIDC trust condition. Find it with: gh api repos/<owner>/<repo> --jq .owner.id"
  type        = string
  default     = "35611714" # kunduso
}

variable "pipeline_role_name" {
  description = "Name of the pipeline role that GitHub Actions assumes via OIDC."
  type        = string
  default     = "autopilot-pipeline-role"
}

variable "apply_role_name" {
  description = "Name of the apply role that the pipeline role assumes to run terraform apply."
  type        = string
  default     = "autopilot-apply-role"
}

variable "state_bucket" {
  description = "S3 bucket holding the infra Terraform state. Both roles need access to read/write/lock it."
  type        = string
  default     = "terraform-remote-state-076680484948"
}

variable "state_key_prefix" {
  description = "Key prefix within the state bucket for the infra state, used to scope state access."
  type        = string
  default     = "tf/aws-iam-auto-pilot"
}

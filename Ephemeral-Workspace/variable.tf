variable "region" {
  description = "The AWS region to provision resources."
  type        = string
  default     = "us-east-2"
}
variable "access_key" {
  description = "The IAM access_key."
  type        = string
  sensitive   = true
}
variable "secret_key" {
  description = "The IAM secret_key."
  type        = string
  sensitive   = true
}
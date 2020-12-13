##################################################################################
# VARIABLES
##################################################################################
variable "region" {
  description = "The region where to provision resources"
  type        = string
}
variable "access_key" {
  description = "The access_key that belongs to the IAM user"
  type        = string
}
variable "secret_key" {
  description = "The secret_key that belongs to the IAM user"
  type        = string
}
variable "private_key_path" {}
variable "key_name" {}
variable "network_address_space" {
  default = "10.1.0.0/16"
}
variable "subnet1_address_space" {
  default = "10.1.0.0/24"
}
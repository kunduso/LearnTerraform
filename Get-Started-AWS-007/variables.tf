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
  type = map(string)
}
variable "instance_size" {
  type = map(string)
}
variable "subnet_count" {
  type = map(number)
}
variable "instance_count" {
  type = map(number)
}
variable "bucket_name_prefix" {}
variable "billing_code_tag" {}
  variable "region" {
    description = "The region where to provision resources"
    type = string
}
variable "access_key" {
    description = "The access_key that belongs to the IAM user"
    type = string
}
variable "secret_key" {
    description = "The secret_key that belongs to the IAM user"
    type = string
}
variable "bucket_name" {
    description = "The name of S3 bucket"
    default = "terraform-bucket"
    type = string
}
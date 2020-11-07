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
    type = list(string)
    default = ["beans", "pepper", "tomato"]
}
variable "ami_location" {
  type = map
  default = {
    us-east-1 = "ami-0412e100c0177fb4b"
    us-east-2 = "ami-0354df7841220296c"
  }
}
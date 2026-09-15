## Introduction
In module 5, I had two EC2 instances running in two subnets in different availability zones inside a VPC, and these two EC2 instances were serving requests coming in from an elastic load balancer. In this module, we are adding an S3 bucket to the infrastructure. The S3 bucket will host the website files, and the two EC2 instances will pull the website files from the S3 bucket and publish them. We need to give permission to the two EC2 instances to pull information out of the S3 bucket (via an IAM role). The logs from the EC2 instances will also get stored in the S3 bucket, so the two EC2 instances need read and write permission to the S3 bucket. I also tag these resources to be able to uniquely identify them.

## To use this code
Rename the `terraform.tfvars.example` file to `terraform.tfvars` and update the values of the variables. Prior to running `terraform init`, ensure a key-pair is created in the same location that you have in the `terraform.tfvars` (in my case it is us-east-2, so the key-pair was created in the same region).

I ran the below commands from the same location where the `.tf` files were stored:

```bash
terraform init
terraform fmt   # optional
terraform plan -out globodeploy.tfplan
terraform apply "globodeploy.tfplan"
```

Once done, I was able to launch the webpage from the output of `aws_elb_public_dns`. After I was convinced this was working as expected, I destroyed the resources using the command:

```bash
terraform destroy
```

## Observation/Errors
The first time I ran `terraform apply`, I got a strange error on the nginx code running on the EC2 instances as part of the `remote-exec` provisioner. The output statement was not verbose — just that an error occurred on line 1 of nginx, line 2 of nginx, etc. I checked that the web page launched correctly, so it was not that the EC2 instances were having issues reaching the S3 bucket. I logged in to my AWS console and found there was no folder named `nginx` in the `globo-dev-xxxxx` bucket. There was only one folder — `website`. That gave me a hint: the first few statements in the `provisioner "remote-exec"` block were actually to copy the logs. I checked ned1313's readme for more info and found an interesting detail about [line-endings](https://github.com/ned1313/Getting-Started-Terraform#line-endings). I made that change and reran, and this time there were no errors. The `nginx` folder was also listed inside the bucket.

When I tried to commit this code, on `git add .` I got a warning message that `LF will be replaced by CRLF in Get-Started-AWS-006/ec2.tf`. I got this message for all the files, so I'll have to remember to update that before I rerun this code.

> This is an early learning example that authenticates with long-lived IAM user keys and an EC2 key-pair; see [`add-github-oidc-role`](../add-github-oidc-role/ReadMe.md) for the OpenID Connect approach that avoids static keys.

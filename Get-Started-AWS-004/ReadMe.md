## Introduction
The contents of this folder just pick up from the previous one, [AWS-003](../Get-Started-AWS-003/ReadMe.md). In the previous module I learnt how to create a new VPC, internet gateway, subnet, route table, and route table association. In this module, I am utilizing the existing default VPC (`aws_default_vpc`).

## To use this code
Rename the `terraform.tfvars.example` file to `terraform.tfvars` and update the values of the variables. Prior to running `terraform init`, ensure a key-pair is created in the same location that you have in the `terraform.tfvars` (in my case it is us-east-2, so the key-pair was created in the same region).

I ran the below commands from the same location where the `.tf` files were stored:

```bash
terraform init
terraform fmt   # optional
terraform plan -out ec2provision.tfplan
terraform apply "ec2provision.tfplan"
```

Once done, I was able to log in to the machine with the value provided in the outputs, the `public_dns` of the machine. After I was convinced this was working as expected, I destroyed the resources using the command:

```bash
terraform destroy
```

> This is an early learning example that authenticates with long-lived IAM user keys and an EC2 key-pair; see [`add-github-oidc-role`](../add-github-oidc-role/ReadMe.md) for the OpenID Connect approach that avoids static keys.

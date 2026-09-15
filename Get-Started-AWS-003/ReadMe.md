## Introduction
The contents of this repo have the necessary information to be able to provision a Linux EC2 machine and run a remote-exec on that. I followed Ned Bellavance's course in Pluralsight to learn more about Terraform. [PluralSight Course: Terraform - Getting Started](https://app.pluralsight.com/library/courses/getting-started-terraform)

## Where I got stuck
Although I was using Terraform on Windows, I did not pay attention to the fact that a single backslash is the escape character and hence was getting strange errors in the line where I was declaring the value for `private_key_path` (declared in the `.tfvars` file and is not part of this repo). I have a `terraform.tfvars.example` file (which is part of this repo) where I provided some more details.

## To use this code
Rename the `terraform.tfvars.example` file to `terraform.tfvars` and update the values of the variables. Prior to running `terraform init`, ensure a key-pair is created in the same location that you have in the `terraform.tfvars` (in my case it is us-east-2, so the key-pair was created in the same region).

I ran the below commands from the same location where the `.tf` files were stored:

```bash
terraform init
terraform fmt   # optional
terraform plan -out ec2provision.tfplan
terraform apply "ec2provision.tfplan"
```

Once done, I was able to launch the webpage with the value provided in the outputs, the `public_dns` of the machine. After I was convinced this was working as expected, I destroyed the resources using the command:

```bash
terraform destroy
```

## Error received
While working, I received this error:

```
Error: Error launching source instance: InvalidKeyPair.NotFound: The key pair '$(pemfilename).pem' does not exist
        status code: 400, request id: $(a-long-sequence-of-alpha-numberic-sequence)
```

The fix was to update the pem file key name. I was providing the value of the variable as `Terraform-Keypair.pem`, when the correct value of the `key_name` is `Terraform-Keypair`.

> This is an early learning example that authenticates with long-lived IAM user keys and an EC2 key-pair; see [`add-github-oidc-role`](../add-github-oidc-role/ReadMe.md) for the OpenID Connect approach that avoids static keys.

## Introduction
In this module I am going to explore using `terraform workspace`.

## To use this code
Rename the `terraform.tfvars.example` file to `terraform.tfvars` and update the values of the variables. Prior to running `terraform init`, ensure a key-pair is created in the same location that you have in the `terraform.tfvars` (in my case it is us-east-2, so the key-pair was created in the same region).

I ran the below commands from the same location where the `.tf` files were stored:

```bash
terraform init
terraform fmt          # optional
terraform workspace list   # lists available workspaces; the current one is marked with a *
terraform workspace new Development   # create and switch to a new "Development" workspace
terraform plan -out globodeploy.tfplan
terraform apply "globodeploy.tfplan"
```

By default, the `default` workspace is selected. Once done, I was able to launch the webpage from the output of `aws_elb_public_dns`. After I was convinced this was working as expected, I destroyed the resources using the command:

```bash
terraform destroy
```

> This is an early learning example that authenticates with long-lived IAM user keys and an EC2 key-pair; see [`add-github-oidc-role`](../add-github-oidc-role/ReadMe.md) for the OpenID Connect approach that avoids static keys.

## Motivation
I had heard about Terraform as a good solution to infrastructure as code approach. I have been using idempotent powershell scripts as a way to achieve that objective which is imperative (procedural) rather than declarative (as Terraform is). And that too, once the infrastructure (virtual machunes) were already provisioned. However, as I moved further and further into infrastructure as code process, I started realizing that there should be an efficient way of also provisioning the underlying infrastructure (virtual machines in this case). This repository is to capture my learning using terraform. My objective is to be able to run a few use cases, e.g. how to provision a VM in Azure and AWS and also be able to remote (for windows OS) into it. As I learn more I will add more use cases to this repository.

## Approach
To begin with, most of my hands on learnings are going to be following tutorials/getting started docs available at: <br />[Get Started - Azure](https://learn.hashicorp.com/collections/terraform/azure-get-started)
<br />[Get Started - AWS](https://learn.hashicorp.com/collections/terraform/aws-get-started)

## Prerequistes
Installation is available as part of getting stated documentations at https://www.terraform.io/

## Usage:
- start with <code>terraform init</code> in the folder where the .tf file exists
<br />- followed by <code>terraform plan -out ${PlanFileName}.tfplan</code>
<br />- next <code>terraform apply ${PlanFileName}.tfplan</code>
<br />- in-order to not be prompted for each <code>terraform apply</code> and <code>terraform destroy</code> command, add <code>--auto-approve</code> at the end. But do not use this the first time to provision an instance, since that might result in incorrect provisioning and without the review, it might take longer to identify and correct the error.

## Notes:
-when creating a new repository for terraform please be careful what kind of files are being commited (we do not want sensetive files like state and tfvars to be commited at all). Use .gitignore effectively in this case.
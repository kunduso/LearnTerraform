# Terraform Learning Repository

## Introduction

Welcome to this repository, which is focused on learning **Terraform** for Infrastructure as Code (IaC). Initially, I was using PowerShell scripts to manage infrastructure, but these were procedural and not as efficient or flexible as Terraform's declarative approach. As I began exploring Terraform, I saw the benefits of using a unified language for provisioning infrastructure across multiple cloud platforms, like **AWS** and **Azure**.

This repository captures my journey in learning Terraform, and my goal is to share what I’ve learned with you. It includes step-by-step examples of how to use Terraform to provision **virtual machines (VMs)** in both **AWS** and **Azure**, and how to remotely access them (for Windows OS). Over time, I will continue to expand the repository with more use cases as I deepen my knowledge and learn new concepts in Terraform.

The motivation behind this repository is to provide practical, beginner-friendly examples that demonstrate how to use Terraform in real-world scenarios. Additionally, I'm including a new section that focuses on **HCP Terraform (HashiCorp Cloud Platform)**—a managed service for running Terraform in a more integrated and streamlined way.

## Approach

To begin with, most of my hands-on learnings are going to be following tutorials/getting started docs available at: 

- [Get Started - Azure](https://learn.hashicorp.com/collections/terraform/azure-get-started)
- [Get Started - AWS](https://learn.hashicorp.com/collections/terraform/aws-get-started)

## Prerequisites

Before you start, make sure to install **Terraform**. You can find installation instructions in the official documentation:

- [Terraform Installation Guide](https://www.terraform.io/)

## Repository Structure

This repository is organized into various folders, each corresponding to different tutorials and use cases for Terraform. The structure is as follows:

- **Get-Started-AWS-001** to **Get-Started-AWS-007**: Terraform use cases for provisioning resources on AWS.
- **Get-Started-Azure-001** and **Get-Started-Azure-002**: Terraform use cases for provisioning resources on Azure.
- **Get-Started-AWS-009-CI-CD-AzureDevops**: Demonstrates how to use Terraform with **Azure DevOps** to provision resources in **AWS** as part of a CI/CD pipeline.
- **Get-Started-UsingVariables**: Uses the `count` construct to create multiple AWS cloud resources of the same type.
- **Get-Started-HCP-Terraform**: Uses **HCP Terraform** (HashiCorp Cloud Platform) to show how to use Terraform in a managed environment.

You can explore each of these folders to find specific examples and step-by-step guides.

## Usage

### Initialize Terraform

Start by initializing the working directory:

````
terraform init
````
### Plan the Infrastructure
After initializing, create an execution plan that shows the changes Terraform will make:

````
terraform plan -out ${PlanFileName}.tfplan
````
### Apply the Plan
Now, apply the changes defined in the plan to provision the infrastructure:
````
terraform apply ${PlanFileName}.tfplan
````
### Destroy the Resources
Once you're done and want to clean up the resources, run the destroy command:

````
terraform destroy
````
To skip prompts and automatically approve the operations (use with caution), add the `--auto-approve` flag:

````
terraform apply --auto-approve

terraform destroy --auto-approve
````
Note: It's advisable not to use `--auto-approve` for the first time to provision resources to ensure you review the execution plan for correctness.

## Notes
When creating a new repository for Terraform, be careful about which files are committed. Sensitive files like `terraform.tfstate` and `tfvars` should not be committed to version control. Use a [`.gitignore`](.gitignore) file to ensure that these are excluded.
The repository currently demonstrates open-source Terraform, but the new HCP Terraform folder shows how to leverage a managed service for Terraform from HashiCorp.
## Contributing
Feel free to fork the repository, make your own modifications, or contribute new use cases! If you find any bugs or have suggestions for improvements, open an issue or submit a pull request.
## License
This project is licensed under the Unlicense - see the [LICENSE](LICENSE) file for details.
## Acknowledgements
I would like to thank the Terraform community and the official documentation, which has been a great resource for learning and improving my skills.
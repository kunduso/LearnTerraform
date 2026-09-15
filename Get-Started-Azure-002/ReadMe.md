## Motivation
Building on creating an Azure Service Principal in the previous module, this example provisions a Linux virtual machine in Azure along with the networking resources it needs.

## What it creates
Using the `azurerm` provider, in the `westus2` location:
- A resource group (`myTFResourceGroup`)
- A virtual network (`10.0.0.0/16`) and a subnet (`10.0.1.0/24`)
- A static public IP
- A network security group with an inbound SSH (port 22) rule
- A network interface
- A Linux virtual machine

## Usage
```bash
terraform init
terraform plan -out azure-vm.tfplan
terraform apply "azure-vm.tfplan"
```
Provide values for `admin_username` and `admin_password` (the password must meet Azure complexity requirements), for example through a `.tfvars` file or environment variables. Authenticate to Azure first (for example, with the Service Principal from [Get-Started-Azure-001](../Get-Started-Azure-001/ReadME.md) or `az login`). Do not commit credentials to version control.

When finished, clean up with:
```bash
terraform destroy
```

> **Security note:** The network security group allows inbound SSH (port 22) from any source (`*`). This is convenient for learning but unsafe for real use — restrict the source address to known IPs.

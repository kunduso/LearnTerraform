## Motivation
I learnt about Azure Service Principal and how to create them from the commandline. I went through an informative article by Ned Bellavance on that subject. My intention was to be able to create a Azure Service Principal and then use the credentials to be able to provision a Resource group in Azure.

## Command
### Create service principal: <code>az ad sp create-for-rbac --name $(app-name) --role "Contributor" --scope "/subscriptions/$(your-subscription-id)" --years $(N)</code>
</br>

### Console output:
{
</br>  "appId": "$(appId)",
</br>  "displayName": "$(app-name)",
</br>  "name": "http://$(app-name)",
</br>  "password": "$(password)",
</br>  "tenant": "$(tenant)"
</br>}


## Command
### Delete service pricipal: <code>az ad sp delete --id $(appId)</code>
</br>

## Usage
The values received from the console output of <code>az ad sp create-for-rbac</code> are mapped to terraform variables. Details at [Terraform -creating a service principal](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret#creating-a-service-principal)
## Reference Articles
[Microsoft Docs](https://docs.microsoft.com/en-us/cli/azure/create-an-azure-service-principal-azure-cli)

[Demystifying Azure AD Service Principals TL;DR -Read Conclusion](https://nedinthecloud.com/2019/07/16/demystifying-azure-ad-service-principals/)
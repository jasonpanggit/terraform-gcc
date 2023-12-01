# Terraform for GCC scaffolding
Terraform for GCC scaffolding is a terraform module which quickly provisions a GCC landing zone based on user configuration

## Project Structure
* .devcontainer - build a devcontainer in Ubuntu with ansible, azure cli, jinja, terraform
* modules/scaffolding - containing the module that does the scaffolding
* scripts - folder containing the scripts used for vm extension

## Scaffolding Files
* scaffold.tf - module that injects the generated TF VARS file into the scaffolding modules
* variables.tf - contains the base variables and default values that are required by the scaffolding modules

## How to scaffold
1. Reopen folder in container (this will build a Ubuntu container using the configuration in .devcontainer folder for the the first time)
2. It uses Ansible and Jinja2 to generate a landing zone tfvars file (i.e. generated-landing-zone.tfvars) based on user configuration which is then pass to terraform plan|apply using -var-file param.
3. See ansible folder README for more details on execution.

## Importing GCC existing resources (e.g. resource groups, vnets)
To import existing resource group
```
terraform import -var-file generated-landing-zone.tfvars module.resource_group.azurerm_resource_group.resource_groups[\"internet_ingress_rg"] /subscriptions/<subscription-id>/resourceGroups/<resource-group-name>
```
To import existing virtual network
```
terraform import -var-file generated-landing-zone.tfvars module.network.azurerm_virtual_network.virtual_networks[\"internet_ingress_vnet\"] /subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.Network/virtualNetworks/<vnet-name>
```
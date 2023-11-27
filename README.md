# Terraform for GCC scaffolding
Terraform for GCC scaffolding is a terraform module which quickly provisions a GCC scaffolding for the following scenarios

* Basic Intranet Zone vnet provisioning 
* AVD AAD join VMs in Internet Zone
* AKS private cluster in Intranet Zone with egress restriction using Azure Firewall
* On-premise DNS forwarding to Intranet Zone

## Project Structure
* modules/scaffolding - containing the module that does the scaffolding
* scripts - folder containing the scripts used for vm extension

## Scaffolding Files
* scaffold.tf - module that injects the TF VARS values into the scaffolding modules
* variables.tf - contains the base variables and default values that are required to generate the scaffolding

## New Feature
1. Using devcontainer
2. Using Ansible and Jinja2 to generate landing zone tfvars file based on config. See ansible folder for more details.

## How to scaffold (not working on this approach anymore)
1. Duplicate one of the TF VARS template.
2. Edit the new tfvars file accordingly.
3. Feel free to make changes to the scaffolding module as you deem fit.
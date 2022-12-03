# Terraform for GCC AIAS models scaffolding
##### Authored by: Jason Pang  

Terraform for GCC scaffolding is an terraform template which quickly provisions a GCC scaffolding.

## Project Structure
aks - provision a AKS private cluser with egress restriction using Azure Firewall
h-model - provision a GCC H-Model with internet, intranet and management vnet
i-model - provision a GCC I-Model with internet and management vnet
modules/gcc/scaffolding - containing the module that does the scaffolding

## Scaffolding Files
scaffold.tf - module that injects the values to the scaffolding module
variables.tf - contains the base variables and default values that are required to generate the scaffolding

## How to scaffold
1. Create a new folder and copy scaffold.tf, resources.tf and variables.tf from any of the folders to new folder
2. Add/Edit/Delete variables in variables.tf (e.g. vnet, subnets, nsg, nsg rules, etc.) and create your own tfvars file to inject the values of the variables accordingly.
3. Feel free to make changes to the scaffolding module as you deem fit.
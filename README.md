# Terraform for GCC scaffolding
Terraform for GCC scaffolding is an terraform template which quickly provisions a GCC scaffolding.

## Project Structure
* h_model.tfvars.template - tfvars template to provision a GCC H-Model
* i_model.tfvars.template - tfvars template to provision a GCC I-Model
* i_model_aks_private_cluster.tfvars.template - tfvars template to provision a GCC I-Model with AKS private cluster
* modules/gcc/scaffolding - containing the module that does the scaffolding
* scripts - folder containing the bash scripts used for linux vm extension

## Scaffolding Files
* scaffold.tf - module that injects the TF VARS values into the scaffolding modules
* variables.tf - contains the base variables and default values that are required to generate the scaffolding

## How to scaffold
1. Duplicate one of the TF VARS template.
2. Edit the new tfvars file accordingly.
3. Feel free to make changes to the scaffolding module as you deem fit.

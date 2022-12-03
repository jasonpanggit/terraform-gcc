# Terraform for GCC AIAS models scaffolding
##### Authored by: Jason Pang  

Terraform for GCC scaffolding is an terraform template which quickly provisions a scaffolding of any of the AIAS models based on the variable values.

## Project Structure
modules/gcc/scaffolding folder - containing the module that does the scaffolding
variables.tf - contains the base variables and default values that are required to generate a scaffolding

## How to scaffold
1. Create a new folder and copy scaffold.tf, resources.tf and variables.tf from root folder to new folder
2. Comment out the unnecessary items in the variables' default value (e.g. intranet vnet, subnets, nsg, nsg rules, etc.) or create your own tfvars file and comment out the necessary items there. This approach allows you to have separate tfvars file for different setup. 

## Additional
terraform_vm.tf - provisions a terraform vm as a tooling vm with file system mirror for internet isolation (Note: For the setup, public IP and internet access is required. Once setup, you need to remove the internet access and it will use the cached providers' packages locally.) 
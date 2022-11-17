# Terraform for GCC AIAS models scaffolding
##### Authored by: Jason Pang  

Terraform for GCC AIAS models scaffolding is an terraform template which quickly provisions a scaffolding of any of the AIAS models based on the variable values.

## Project Structure
modules/aias/models/scaffolding folder - containing the module that does the scaffolding
variables.tf - contains the variables and default values that are required to generate a H-model scaffolding

## How to scaffold other models e.g. i-model
Comment out the unnecessary items in the variables' default value (e.g. intranet vnet, subnets, nsg, nsg rules, etc.). Another better approach is to create your own tfvar file and comment out the necessary items there. This approach allows you to have separate tfvar file for different model. 

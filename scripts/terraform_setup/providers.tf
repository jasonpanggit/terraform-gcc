terraform {
  required_version = "~>1.1.8"
  required_providers {
    # add/update the providers and details
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.28"
    }
  }
}
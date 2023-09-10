terraform {
  backend "azurerm" {
    container_name       = ""
    key                  = "terraform.tfstate"
    storage_account_name = ""
  }
}

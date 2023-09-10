terraform {
  backend "azurerm" {
    resource_group_name  = "kkaarel_dev001"
    container_name       = "tfstatestreamlitappad"
    key                  = "terraform.tfstate"
    storage_account_name = "kkkaarel"
  }
}

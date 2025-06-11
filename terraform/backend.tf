terraform {
  backend "azurerm" {
    resource_group_name  = ""
    container_name       = "tfstatestreamlitappad"
    key                  = "terraform.tfstate"
    storage_account_name = ""
    subscription_id      = ""
  }
}

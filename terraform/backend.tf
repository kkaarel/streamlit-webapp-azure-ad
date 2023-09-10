terraform {
backend "azurerm" {
  container_name       = "tfstatestreamlitappad"
  key                  = "terraform.tfstate"
  storage_account_name = "kkkaarel"

  }
}
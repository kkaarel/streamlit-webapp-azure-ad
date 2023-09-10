provider "azurerm" {
  skip_provider_registration = true
  version = "~>0.13"
  features {}
  use_oidc = true
}



provider "azurerm" {
  skip_provider_registration = true
  version = "~>2.0"
  features {}
  use_oidc = true
}



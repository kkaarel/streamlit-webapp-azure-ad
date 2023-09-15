//resource group is created before hand
//storage account and container are created before hand for state files


data "azurerm_client_config" "current" {

}

output "ARM_TENANT_ID" {
  value = data.azurerm_client_config.current.tenant_id
}


data "azurerm_resource_group" "main" {
  name = var.RESOURCE_GROUP_NAME

}



resource "azurerm_storage_account" "tfstate" {
  name                     = "kkkaarel"
  resource_group_name      = data.azurerm_resource_group.main.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

}




resource "azurerm_service_plan" "streamlit" {
  name                = "ASP-${var.project}-${terraform.workspace}"
  location            = "West Europe"
  resource_group_name = data.azurerm_resource_group.main.name
  os_type             = "Linux"
  sku_name            = "B1"

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      tags
    ]
  }

}



resource "azurerm_linux_web_app" "app" {
  name                = "WEBAPP-${var.project}-${terraform.workspace}"
  location            = var.location
  service_plan_id     = azurerm_service_plan.streamlit.id
  resource_group_name = data.azurerm_resource_group.main.name
  https_only          = true

  identity {
    type = "SystemAssigned"
  }


  auth_settings_v2 {
    auth_enabled           = true
    require_authentication = true
    default_provider       = "azureactivedirectory"
    unauthenticated_action = "RedirectToLoginPage"

    active_directory_v2 {
      // The application is pre created from Azure, this is for security puropses so that the deployment script would only have rights to create resources.
      client_id                   = var.client_id_ad
      client_secret_setting_name  = "MICROSOFT_PROVIDER_AUTHENTICATION_SECRET"
      tenant_auth_endpoint        = "https://sts.windows.net/${var.ARM_TENANT_ID}/v2.0"
      www_authentication_disabled = false
    }

    login {
      token_store_enabled = true

    }
  }

  site_config {
    app_command_line = "python -m streamlit run streamlit/app.py  --server.port 8000 --server.address 0.0.0.0"



    application_stack {
      python_version = "3.10"
    }
  }

  app_settings = {
    "SCM_DO_BUILD_DURING_DEPLOYMENT" = 1
    # Add other app settings as needed
  }
}


// This data block retrieves Azure client configuration.
data "azurerm_client_config" "current" {

}

// This data block retrieves information about the Azure resource group defined by var.RESOURCE_GROUP_NAME.
data "azurerm_resource_group" "main" {
  name = var.RESOURCE_GROUP_NAME
}

// This archive_file block creates a ZIP archive from the "./streamlit" directory.

data "archive_file" "app" {
  type        = "zip"
  source_dir  = "./streamlit"
  output_path = var.archive_file_streamlit
}

// This resource block creates an Azure Storage Account for Terraform state files.
resource "azurerm_storage_account" "tfstate" {
  name                     = var.STORAGE_ACCOUNT_NAME
  resource_group_name      = data.azurerm_resource_group.main.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

// This resource block creates an Azure Service Plan.
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

// This resource block creates an Azure Linux Web App.
resource "azurerm_linux_web_app" "app" {
  name                = "WEBAPP-${var.project}"
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
      // The application is pre-created in Azure; this setting enhances security.
      client_id                   = var.CLIENT_ID_AD
      client_secret_setting_name  = "MICROSOFT_PROVIDER_AUTHENTICATION_SECRET"
      tenant_auth_endpoint        = "https://sts.windows.net/${var.ARM_TENANT_ID}/v2.0"
      www_authentication_disabled = false
    }

    login {
      token_store_enabled = true
    }
  }

  site_config {
    app_command_line = "python -m streamlit run app.py  --server.port 8000 --server.address 0.0.0.0"

    application_stack {
      python_version = "3.10"
    }
  }

  app_settings = {
    "SCM_DO_BUILD_DURING_DEPLOYMENT" = 1
    // Add other app settings as needed
  }
}

// This local block defines a command for publishing code to the Azure Web App (Linux).
locals {
  publish_code_command_linux = "az webapp deployment source config-zip --resource-group ${azurerm_linux_web_app.app.resource_group_name} --name ${azurerm_linux_web_app.app.name} --src ${var.archive_file_streamlit}"
}

// This null_resource block publishes code to the Azure Web App (Linux) using the local-exec provisioner.
resource "null_resource" "app" {
  provisioner "local-exec" {
    command = local.publish_code_command_linux
  }
  depends_on = [local.publish_code_command_linux, local_file.secrets]
  triggers = {
    input_json            = filemd5(var.archive_file_streamlit)
    publish_code_command = local.publish_code_command_linux
  }
}


// Add secrets to .streamlit/secrets.toml

resource "local_file" "secrets" {
  content  = var.SECRETS_STREAMLIT
  filename = ".streamlit/secrets.toml"

}

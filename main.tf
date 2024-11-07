# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.65.0"
    }
  }

  required_version = ">= 1.0"
}

provider "azurerm" {
  features {}
}

# Create resource group

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_location

  tags = {
    Environment = "TerraformBaseStructure"
  }

  lifecycle {
    prevent_destroy = false
  }
}


# Create app service plan

resource "azurerm_service_plan" "appserviceplan" {
  name                = var.service_plan_name
  location            = var.resource_location
  resource_group_name = azurerm_resource_group.rg.name
  os_type = "Linux"
  sku_name = "B1"
  
}

# Create webapp for frontend
resource "azurerm_linux_web_app" "frontend_webapp" {
  name                = var.frontend_app_name
  location            = var.resource_location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.appserviceplan.id # this will fetch the id of the app service plan created in previous step

  
  site_config {
     application_stack {
        node_version = "20-lts"
     }  
  }
}


# Create webapp for backend
resource "azurerm_linux_web_app" "backend_webapp" {
  name                = var.backend_app_name
  location            = var.resource_location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.appserviceplan.id # this will fetch the id of the app service plan created in previous step

 
  site_config {
    application_stack {
      python_version = "3.12"
    }
  }
}


# Create a MySQL Database
resource "azurerm_mysql_flexible_server" "mysql" {
  name                = var.mysql_servername
  location            = "eastus"
  resource_group_name = azurerm_resource_group.rg.name
  administrator_login          = var.mysql_db_username
  administrator_password = var.mysql_db_password
  backup_retention_days = 7
  sku_name = "GP_Standard_D2ds_v4"

}


# Output the web app URLs and MySQL server hostname
output "frontend_url" {
  value = azurerm_linux_web_app.frontend_webapp.default_site_hostname
}

output "backend_url" {
  value = azurerm_linux_web_app.backend_webapp.default_site_hostname
}

output "mysql_hostname" {
  value = azurerm_mysql_flexible_server.mysql.fqdn
}
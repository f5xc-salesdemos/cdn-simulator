terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

data "azurerm_client_config" "current" {}

locals {
  # Deterministic 8-char suffix derived from the authenticated user's Azure object_id.
  # Same person always gets the same suffix across destroy/redeploy cycles.
  suffix              = substr(sha1(data.azurerm_client_config.current.object_id), 0, 8)
  resource_group_name = var.resource_group_name != "" ? var.resource_group_name : "rg-cdn-simulator-${local.suffix}"
}

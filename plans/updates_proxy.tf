#
# This terraform plan defines the resources necessary to host azure.updates.jenkins.io
# updates-proxy.jenkins.io only contains htaccess files generated by https://github.com/jenkins-infra/update-center2/pull/224.
# This service acts as a fallback updates.jenkins.io
#

resource "azurerm_resource_group" "updates-proxy" {
    name     = "${var.prefix}updates-proxy"
    location = "${var.location}"
    tags {
        env = "${var.prefix}"
    }
}

resource "azurerm_storage_account" "updates-proxy" {
    name                     = "${var.prefix}updatesproxy"
    resource_group_name      = "${azurerm_resource_group.updates-proxy.name}"
    location                 = "${var.location}"
    account_tier             = "Standard"
    account_replication_type = "GRS"
    depends_on               = ["azurerm_resource_group.updates-proxy"]
    tags {
        env = "${var.prefix}"
    }
}

resource "azurerm_storage_share" "updates-proxy" {
    name = "updates-proxy"
    resource_group_name     = "${azurerm_resource_group.updates-proxy.name}"
    storage_account_name    = "${azurerm_storage_account.updates-proxy.name}"
    depends_on              = ["azurerm_resource_group.updates-proxy","azurerm_storage_account.updates-proxy"]
}
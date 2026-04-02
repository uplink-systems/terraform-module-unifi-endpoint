####################################################################################################
#   data.tf                                                                                        #
####################################################################################################

data "unifi_network" "network" {
    count = var.endpoint.network == null ? 0 : 1
    name  = var.endpoint.network
    site  = var.endpoint.site
}

data "unifi_client_qos_rate" "client_qos_rate" {
    count = var.endpoint.client.qos_group_name == null ? 0 : 1
    name  = var.endpoint.client.qos_group_name
    site  = var.endpoint.site
}
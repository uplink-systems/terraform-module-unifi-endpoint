####################################################################################################
#   data.tf                                                                                        #
####################################################################################################

data "unifi_network" "network" {
    count = var.endpoint.network == null ? 0 : 1
    name  = var.endpoint.network
    site  = var.endpoint.site
}

data "unifi_client_group" "client_group" {
    count = var.endpoint.client.client_group == null ? 0 : 1
    name  = var.endpoint.client.client_group
    site  = var.endpoint.site
}
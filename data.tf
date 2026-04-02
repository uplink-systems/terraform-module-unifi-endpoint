####################################################################################################
#   data.tf                                                                                        #
####################################################################################################

data "unifi_network" "network" {
    count = var.endpoint.network == null ? 0 : 1
    name  = var.endpoint.network
    site  = var.endpoint.site
}

data "unifi_user_group" "user_group" {
    count = var.endpoint.user.user_group == null ? 0 : 1
    name  = var.endpoint.user.user_group
    site  = var.endpoint.site
}

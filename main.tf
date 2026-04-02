###################################################################################################
#   main.tf                                                                                       #
###################################################################################################

resource "unifi_client" "client" {
    mac                         = var.endpoint.mac
    name                        = var.endpoint.name
    network_id                  = var.endpoint.network == null ? null : data.unifi_network.network[0].id
    site                        = var.endpoint.site
    allow_existing              = var.endpoint.client.allow_existing == null ? true : var.endpoint.client.allow_existing
    blocked                     = var.endpoint.client.blocked == null ? false : var.endpoint.client.blocked
    groups                      = var.endpoint.client.groups
    fixed_ap_mac                = var.endpoint.client.fixed_ap_mac
    fixed_ip                    = var.endpoint.client.fixed_ip
    local_dns_record            = var.endpoint.client.fixed_ip == null ? null : var.endpoint.client.local_dns_record
    note                        = var.endpoint.client.note
    skip_forget_on_destroy      = var.endpoint.client.skip_forget_on_destroy == null ? false : var.endpoint.client.skip_forget_on_destroy
    qos_rate                    = var.endpoint.client.qos_group_name == null ? null : {"id" = data.unifi_client_qos_rate.client_qos_rate[0].id}
}

resource "unifi_account" "account" {
    count                       = var.endpoint.account.enabled ? 1 : 0
    name                        = upper(join("", (split(":", var.endpoint.mac))))
    password                    = upper(join("", (split(":", var.endpoint.mac))))
    network_id                  = var.endpoint.network == null ? null : data.unifi_network.network[0].id
    site                        = var.endpoint.site
    tunnel_medium_type          = var.endpoint.account.tunnel_medium_type
    tunnel_type                 = var.endpoint.account.tunnel_type
    depends_on                  = [ unifi_client.client ]
}

###################################################################################################
#   main.tf                                                                                       #
###################################################################################################

resource "unifi_client" "client" {
    mac                     = var.endpoint.mac
    name                    = var.endpoint.name
    network_id              = var.endpoint.network == null ? null : data.unifi_network.network[0].id
    site                    = var.endpoint.site
    allow_existing          = var.endpoint.client.allow_existing == null ? true : var.endpoint.client.allow_existing
    blocked                 = var.endpoint.client.blocked == null ? false : var.endpoint.client.blocked
    dev_id_override         = var.endpoint.client.dev_id_override
    fixed_ip                = var.endpoint.client.fixed_ip
    group_id                = var.endpoint.client.client_group == null ? null : data.unifi_client_group.client_group[0].id
    local_dns_record        = var.endpoint.client.fixed_ip == null ? null : var.endpoint.client.local_dns_record
    note                    = var.endpoint.client.note
    skip_forget_on_destroy  = var.endpoint.client.skip_forget_on_destroy == null ? false : var.endpoint.client.skip_forget_on_destroy
}

resource "unifi_account" "account" {
    count                   = var.endpoint.account.enabled ? 1 : 0
    name                    = upper(join("", (split(":", var.endpoint.mac))))
    password                = upper(join("", (split(":", var.endpoint.mac))))
    network_id              = var.endpoint.network == null ? null : data.unifi_network.network[0].id
    site                    = var.endpoint.site
    tunnel_medium_type      = var.endpoint.account.tunnel_medium_type
    tunnel_type             = var.endpoint.account.tunnel_type
    depends_on              = [ unifi_client.client ]
}

###################################################################################################
#   main.tf                                                                                       #
###################################################################################################

resource "unifi_user" "user" {
    mac                     = var.endpoint.mac
    name                    = var.endpoint.name
    network_id              = var.endpoint.network == null ? null : data.unifi_network.network[0].id
    site                    = var.endpoint.site
    allow_existing          = var.endpoint.user.allow_existing == null ? true : var.endpoint.user.allow_existing
    blocked                 = var.endpoint.user.blocked == null ? false : var.endpoint.user.blocked
    dev_id_override         = var.endpoint.user.dev_id_override
    fixed_ip                = var.endpoint.user.fixed_ip
    local_dns_record        = var.endpoint.user.fixed_ip == null ? null : var.endpoint.user.local_dns_record
    note                    = var.endpoint.user.note
    skip_forget_on_destroy  = var.endpoint.user.skip_forget_on_destroy == null ? false : var.endpoint.user.skip_forget_on_destroy
    user_group_id           = var.endpoint.user.user_group == null ? null : data.unifi_user_group.user_group[0].id
}

resource "unifi_account" "account" {
    count                   = var.endpoint.account.enabled ? 1 : 0
    name                    = upper(join("", (split(":", var.endpoint.mac))))
    password                = upper(join("", (split(":", var.endpoint.mac))))
    network_id              = var.endpoint.network == null ? null : data.unifi_network.network[0].id
    site                    = var.endpoint.site
    tunnel_medium_type      = var.endpoint.account.tunnel_medium_type
    tunnel_type             = var.endpoint.account.tunnel_type
    depends_on              = [ unifi_user.user ]
}

###################################################################################################
#   main.tf                                                                                       #
###################################################################################################

variable "endpoint" {
  type = map(object({
    mac       = string
    name      = string
    network   = optional(string, null)
    site      = optional(string, null)
    client    = {
      allow_existing            = optional(bool, true)
      blocked                   = optional(bool, false)
      fixed_ap_mac              = optional(string, null)
      fixed_ip                  = optional(string, null)
      local_dns_record          = optional(string, null)
      network_members_group_ids = optional(list(string), null)
      note                      = optional(string, null)
      skip_forget_on_destroy    = optional(bool, false)
    }
    account   = optional(object({
      enabled                   = optional(bool, true)
      tunnel_medium_type        = optional(number, null)
      tunnel_type               = optional(number, null)
    }), { enabled = false })
  }))
}

module "unifi_endpoint" {
  for_each  = var.endpoint
  source    = "github.com/uplink-systems/terraform-module-unifi-endpoint"
  endpoint  = each.value
}

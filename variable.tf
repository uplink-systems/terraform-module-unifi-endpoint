###################################################################################################
#   variable.tf                                                                                   #
###################################################################################################

variable "endpoint" {
  description   = "Common variable for ressources managed by the UniFi endpoint module"
  type          = object({
    mac                     = string
    name                    = string
    network                 = optional(string, null)
    site                    = optional(string, "default")
    client                  = optional(object({
      allow_existing            = optional(bool, null)
      blocked                   = optional(bool, null)       
      groups                    = optional(list(string), null)
      fixed_ap_mac              = optional(string, null)
      fixed_ip                  = optional(string, null)
      local_dns_record          = optional(string, null)
      note                      = optional(string, null)
      qos_group_name            = optional(string, null)
      skip_forget_on_destroy    = optional(bool, null)
    }), {})
    account                 = optional(object({
      enabled                   = optional(bool, true)
      tunnel_medium_type        = optional(number, 6)
      tunnel_type               = optional(number, 13)
    }), { enabled = false })
  })
  validation {
    # check if var.endpoint.mac contains a valid MAC address
    condition     = can(regex("^([0-9A-Fa-f]{2}[:]){5}([0-9A-Fa-f]{2})$", var.endpoint.mac))
    error_message = <<-EOF
      Value for 'var.endpoint.mac' is invalid: ${var.endpoint.mac}.
      Must be a valid MAC address in the format 00:1A:2B:3C:4D:5E" or "00:1a:2b:3c:4d:5e" only.
    EOF
  }
  validation {
    # check if var.endpoint.client.fixed_ip is null or contains a valid IPv4 value
    condition     = var.endpoint.client.fixed_ip == null ? true : can(cidrnetmask(join("/", [var.endpoint.client.fixed_ip, "32"])))
    error_message = <<-EOF
      Value for 'var.endpoint.client.fixed_ip' is invalid: ${var.endpoint.client.fixed_ip == null ? 0 : var.endpoint.client.fixed_ip}
      Must be a valid address in IPv4 format or null only.
    EOF
  }
}

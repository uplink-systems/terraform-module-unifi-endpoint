####################################################################################################
#   Variables declaration (Provider variables)                                                     #
####################################################################################################

variable "unifi_api_key" {
  sensitive = true
}
variable "unifi_api_url" {
  sensitive = true
}
variable "unifi_allow_insecure" {
  default   = true
}
variable "unifi_site" {
  default   = null
}
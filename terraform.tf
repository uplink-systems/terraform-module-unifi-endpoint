####################################################################################################
#   terraform.tf                                                                                   # 
####################################################################################################

terraform {
  required_version  = ">= 0.15.0"
  required_providers {
    unifi   = {
      source  = "registry.terraform.io/ubiquiti-community/unifi"
      version = "0.59.0"
    }
  }
}

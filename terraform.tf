####################################################################################################
#   terraform.tf                                                                                   # 
####################################################################################################

terraform {
  required_version  = ">= 1.14.0"
  required_providers {
    unifi   = {
      source  = "registry.terraform.io/ubiquiti-community/unifi"
      version = "<= 0.41.3"
    }
  }
}

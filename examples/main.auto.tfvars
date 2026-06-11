###################################################################################################
#   main.auto.tfvars                                                                              #
###################################################################################################

endpoint = {
  "001A2B3C4D5E" = {
    mac               = "00:1A:2B:3C:4D:5E"
    name              = "desktop_001"
    network           = "vlan_0011"
    client              = {
      blocked           = true
      note              = "Blocked desktop PC of employee XYZ"
      client_group      = "desktops"
    }
  }
  "00A1B2C3D4E5" = {
    mac               = "00:a1:b2:c3:d4:e5"
    name              = "laptop_002"
    client              = {
      fixed_ap_mac      = "12:ab:34:bc:56:de"
      fixed_ip          = "192.168.1.101"
      local_dns_record  = "laptop_002.domain.internal"
      note              = "Laptop of the Big Boss"
      qos_group_name    = "laptops"
    }
    radius_user       = {
      enabled           = true
      vlan              = 2
    }
  }
}

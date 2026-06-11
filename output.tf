####################################################################################################
#   output.tf                                                                                      #
####################################################################################################

output "unifi_client" {
    value       = unifi_client.client
    depends_on  = [ unifi_client.client ]
}

output "unifi_radius_user" {
    value       = unifi_radius_user.radius_user
    depends_on  = [ unifi_radius_user.radius_user ]
}
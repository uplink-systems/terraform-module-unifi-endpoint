####################################################################################################
#   output.tf                                                                                      #
####################################################################################################

output "unifi_client" {
    value       = unifi_client.client
    depends_on  = [ unifi_client.client ]
}

output "unifi_account" {
    value       = unifi_account.account
    depends_on  = [ unifi_account.account ]
}
####################################################################################################
#   output.tf                                                                                      #
####################################################################################################

output "unifi_user" {
    value       = unifi_user.user
    depends_on  = [ unifi_user.user ]
}

output "unifi_account" {
    value       = unifi_account.account
    depends_on  = [ unifi_account.account ]
}
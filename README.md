## Module 'terraform-module-unifi-endpoint'

### Description

This module is intended to create and manage <code>unifi_user</code> resources (client devices) on a Unifi Network Controller (either stand-alone or hosted on a UCG/UDM) following my business needs and standards. Optionally the module can create an associated <code>unifi_account</code> resource for authentication/authorization/accounting (AAA) for wired or wireless networks using UniFi gateway's built-in RADIUS server. It's not possible by design to create a <code>unifi_account</code> resource only without creating a related <code>unifi_user</code> resource. The other way round, this dependency also ensures that <code>unifi_account</code> resources are deleted automatically if their related <code>unifi_user</code> resource is deleted.   
  
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.14.0 |
| <a name="requirement_unifi"></a> [ubiquiti-community\/unifi](#requirement\_ubiquiti-commpunity\_unifi) | <= 0.41.3 |

### Resources

| Name | Type |
|------|------|
| [unifi_user.user](https://registry.terraform.io/providers/ubiquiti-community/unifi/latest/docs/resources/user) | resource |
| [unifi_account.account](https://registry.terraform.io/providers/ubiquiti-community/unifi/latest/docs/resources/account) | resource |

### Inputs
  
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_endpoint"></a> [endpoint](#input\_endpoint) | 'var.endpoint' is the main variable for unifi_user and unifi_account resources' attributes | <pre>type          = object({<br>  mac                     = string<br>  name                    = string<br>  network                 = optional(string, null)<br>  site                    = optional(string, "default")<br>  user                    = optional(object({<br>    allow_existing          = optional(bool, null)<br>    blocked                 = optional(bool, null)<br>    dev_id_override         = optional(number, null)<br>    fixed_ip                = optional(string, null)<br>    local_dns_record        = optional(string, null)<br>    note                    = optional(string, null)<br>    skip_forget_on_destroy  = optional(bool, null)<br>    user_group              = optional(string, null)<br>  }), {})<br>  account                 = optional(object({<br>    enabled                 = optional(bool, true)<br>    tunnel_medium_type      = optional(number, 6)<br>    tunnel_type             = optional(number, 13)<br>  }), { enabled = false })<br>})</pre> | none | yes |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_unif_user"></a> [unifi\_user](#output\_unifi\_user) | list of all exported attributes values from the <code>unifi_user</code> resources (Client device)  |
| <a name="output_unif_account"></a> [unifi\_account](#output\_unifi\_account) | list of all exported attributes values from the <code>unifi_account</code> resources (RADIUS account)  |

### Notes
  
There are several Terraform provider available for UniFi under active development to select from. This module is based on the provider *ubiquiti-community/unifi*. If your code manages resources that are only availabe with another provider (e.g. *filipowm/unifi*, which currently provides more available resources to manage) you have to workaround this depending on which provider is the "main" provider (for details expand the following section *Using multiple UniFi provider*).  

<details>
<summary><b>Using multiple UniFi provider</b></summary>

##### Option 1: *ubiquiti-community/unifi* IS the primary provider for UniFi resources
  
In this case you need to configure and add the secondary provider as an additional (non-defaul) provider with a custom local name. Non-module resources need to be configured with the *provider* parameter if the primary (*ubiquiti-community/unifi*) provider does not provide the resource type and the secondary provider shall be used instead.  

```
terraform {
  required_providers {
    unifi           = {
      source  = "ubiquiti-community/unifi"
      version = "= 0.41.3"
    }
    unifi-secondary-provider  = {
      <your secondary provider for UniFi resources>
    }
  }
}
  
provider "unifi" = {
  api_key         = ...
  api_url         = ...
  ...
}
provider "unifi-secondary-provider" = {
  <your secondary provider's settings>
}
  
module "unifi_endpointt"
  for_each    = ...
  source      = ...
  <Module-specific inputs>

# resource with secondary provider
resource "unifi_setting_usg" "setting_usg_1"
  <Resource-specific inputs>
  provider    = unifi-secondary-provider

# resource with primary provider (*ubiquiti-community/unifi*)
resource "unifi_setting_usg" "setting_usg_2"
  <Resource-specific inputs>

```

##### Option 2: *ubiquiti-community/unifi* IS NOT the primary provider for UniFi resources

In this case you need to configure and add the *ubiquiti-community/unifi* provider as an additional (non-default) provider config with a custom local name when using the module. Non-module resources need to be configured with the *provider* parameter only if the secondary (*ubiquiti-community/unifi*) provider shall be used for the resource.    

```
terraform {
  required_providers {
    unifi           = {
      <your default provider for UniFi resources>
    }
    unifi-secondary-provider  = {
      source  = "ubiquiti-community/unifi"
      version = "0.41.3"
    }
  }
}
  
provider "unifi" = {
  <your default provider's settings>
}
provider "unifi-secondary-provider" = {
  api_key         = ...
  api_url         = ...
  ...
}
  
module "unifi_endpoint"
  for_each    = ...
  source      = ...
  <Module-specific inputs>

# resource with default provider
resource "unifi_setting_usg" "setting_usg_1"
  <Resource-specific inputs>

# resource with secondary provider (*ubiquiti-community/unifi*)
resource "unifi_setting_usg" "setting_usg_2"
  <Resource-specific inputs>
  provider    = unifi-secondary
```
</details>
  
#####
The module can create/manage both, a client device and an associated account for AAA. A UniFi gateway with an enabled built-in RADIUS server must be setup to create associated accounts. Leave the account attributes unconfigured to skip account creation or if a 3rd party gateway is used.  

<details>
<summary><b>Using the <i>endpoint.account</i> parameters</b></summary>

#####
The *endpoint.account* parameters specify the settings for the *unifi_account* resource. If you want to create an account for RADIUS authentication and VLAN assignment only, you only need to set the parameter *endpoint.account.enable* to *true*. The other required parameter values are configured with matching values for this scenario. If you want to configure another type of *unifi_account* you can specify the related parameters instead; *endpoint.account.enable* is set to *true* automatically in this case.
</details>
  
#####
The provider requires that the attributes <code>network_id</code> and <code>user_group_id</code> contain the UniFi-internal ID of the network / user group. However, the name of the objects must be specified in the module variable instead, because it has a built-in feature to transform these names to their corresponding IDs using data sources. That's why the variable's attributes in the module are labeled as <code>network</code> and <code>user_group</code> for better understanding.  
  
The provided mac address is used for both resources, <code>unifi_user</code> and <code>unifi_account</code>. UniFi currently allows several formats for Wireless MAC authentication but only one format Wired MAC authentication ("*AABBCCDDEEFF*"). To setup and use <code>unifi_account</code> resources for both, wired and wireless MAC authentication, the module converts the mac address to this format for username/password.  
  
The attribute <code>fixed_ip</code> can only be used in environments with a UniFi Gateway or a UniFi layer-3 switch. Otherwise the resource will fail to create if not null.  
  
The attribute <code>local_dns_record</code> can only be used in combination with the <code>fixed_ip</code> attribute. To avoid a conflict and error, the module validates the dependency and sets the value to <code>null</code>, too, if <code>fixed_ip</code> is <code>null</code>.  
  
The module uses UniFi's default value for the site name ("default"). The module fails if these defaults have been changed and no custom value is configured in the root module.  
  
<details>
<summary><b>Using the variables in the root module</b></summary>

######
The following lines explain how the main variable in the root module has to be defined with minimum required settings if the module is used with a for_each loop and shall create multiple resources:  

```
variable "endpoint" {
  description = ""
  type        = map(object({
    mac                     = string
    name                    = string
    network                 = optional(string, null)
    site                    = optional(string, null)
    user                    = {
      allow_existing          = optional(bool, true)
      blocked                 = optional(bool, false)
      dev_id_override         = optional(number, null)
      fixed_ip                = optional(string, null)
      local_dns_record        = optional(string, null)
      note                    = optional(string, null)
      skip_forget_on_destroy  = optional(bool, false)
      user_group              = optional(string, null)
    }
    account                 = optional(object({
      enabled                 = optional(bool, null)
      tunnel_medium_type      = optional(number, null)
      tunnel_type             = optional(number, null)
    }))
  }))
}
  
module "endpoint" {
  source                  = "github.com/uplink-systems/terraform-module-unifi-endpoint"
  for_each                = var.endpoint
  endpoint                = each.value
}
```
</details>
  
### Known Issues
  
Known issues are documented with the GitHub repo's issues functionality. Please filter the issues by **Types** and select **Known Issue** to get the appropriate issues and read the results carefully before using the module to avoid negative impacts on your infrastructure.  
  
<a name="known_issues"></a> [list of Known Issues](https://github.com/uplink-systems/terraform-module-unifi-endpoint/issues?q=type%3A%22known%20issue%22)  
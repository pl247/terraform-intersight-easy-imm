#_________________________________________________________________________
#
# Intersight Network Connectivity Policies Variables
# GUI Location: Configure > Policy > Create Policy > Network Connectivity
#_________________________________________________________________________

variable "policies_network_connectivity" {
  default = {
    default = {
      description    = ""
      dns_servers_v4 = ["208.67.220.220", "208.67.222.222"]
      dns_servers_v6 = []
      dynamic_dns    = false
      ipv6_enable    = false
      organization   = "default"
      tags           = []
      update_domain  = ""
    }
  }
  description = <<-EOT
  key - Name of the Network Connectivity Policy.
  * description - Description to Assign to the Policy.
  * dns_servers_v4 - List of IPv4 DNS Servers for this DNS Policy.
  * dns_servers_v6 - List of IPv6 DNS Servers for this DNS Policy.
  * dynamic_dns - Flag to Enable or Disable Dynamic DNS on the Policy.  Meaning obtain DNS Servers from DHCP Service.
  * ipv6_enable - Flag to Enable or Disable IPv6 on the Policy.
  * organization - Name of the Intersight Organization to assign this Policy to.
    - https://intersight.com/an/settings/organizations/
  * tags - List of Key/Value Pairs to Assign as Attributes to the Policy.
  * update_domain - Name of the Domain to Update when using Dynamic DNS for the Policy.
  EOT
  type = map(object(
    {
      description    = optional(string)
      dns_servers_v4 = optional(set(string))
      dns_servers_v6 = optional(set(string))
      dynamic_dns    = optional(bool)
      ipv6_enable    = optional(bool)
      organization   = optional(string)
      tags           = optional(list(map(string)))
      update_domain  = optional(string)
    }
  ))
}


#_________________________________________________________________________
#
# Network Connectivity Policies
# GUI Location: Configure > Policy > Create Policy > Network Connectivity
#_________________________________________________________________________

module "policies_network_connectivity" {
  depends_on = [
    local.org_moids,
    module.ucs_domain_profiles
  ]
  source         = "terraform-cisco-modules/imm/intersight//modules/policies_network_connectivity"
  for_each       = local.policies_network_connectivity
  description    = each.value.description != "" ? each.value.description : "${each.key} Network Connectivity (DNS) Policy."
  dns_servers_v4 = each.value.dns_servers_v4
  dns_servers_v6 = each.value.dns_servers_v6
  dynamic_dns    = each.value.dynamic_dns
  ipv6_enable    = each.value.ipv6_enable
  name           = each.key
  org_moid       = local.org_moids[each.value.organization].moid
  tags           = length(each.value.tags) > 0 ? each.value.tags : local.tags
  update_domain  = each.value.update_domain
  profile_type   = "domain"
  profiles = flatten([
    for s in sort(keys(local.ucs_domain_profiles)) :
    [module.ucs_domain_profiles_a[s].moid, module.ucs_domain_profiles_b[s].moid]
    if local.ucs_domain_profiles[s].profile.policies_network_connectivity == each.key
  ])
}

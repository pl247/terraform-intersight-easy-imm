
#____________________________________________________________
#
# Intersight Pools Module
# GUI Location: Pools > Create Pool
#____________________________________________________________

#______________________________________________
#
# Fibre-Channel Pools
#______________________________________________

module "fc_pools" {
  depends_on = [
    local.org_moids
  ]
  source           = "terraform-cisco-modules/imm/intersight//modules/pools_fc"
  for_each         = local.fc_pools
  assignment_order = each.value.assignment_order
  description      = each.value.description != "" ? each.value.description : "${each.value.organization} ${each.key} ${each.value.pool_purpose} Pool."
  id_blocks        = each.value.id_blocks
  name             = each.key
  org_moid         = local.org_moids[each.value.organization].moid
  pool_purpose     = each.value.pool_purpose
  tags             = each.value.tags != [] ? each.value.tags : local.tags
}


#______________________________________________
#
# IP Pools
#______________________________________________

module "ip_pools" {
  depends_on = [
    local.org_moids
  ]
  source           = "terraform-cisco-modules/imm/intersight//modules/pools_ip"
  for_each         = local.ip_pools
  assignment_order = each.value.assignment_order
  description      = each.value.description != "" ? each.value.description : "${each.value.organization} ${each.key} IP Pool."
  dns_servers_v4   = each.value.dns_servers_v4
  dns_servers_v6   = each.value.dns_servers_v6
  ipv4_block       = each.value.ipv4_block
  ipv4_config      = each.value.ipv4_config
  ipv6_block       = each.value.ipv6_block
  ipv6_config      = each.value.ipv6_config
  name             = each.key
  org_moid         = local.org_moids[each.value.organization].moid
  tags             = each.value.tags != [] ? each.value.tags : local.tags
}


#______________________________________________
#
# IQN Pools
#______________________________________________

module "iqn_pools" {
  depends_on = [
    local.org_moids
  ]
  source            = "terraform-cisco-modules/imm/intersight//modules/pools_iqn"
  for_each          = local.iqn_pools
  assignment_order  = each.value.assignment_order
  description       = each.value.description != "" ? each.value.description : "${each.value.organization} ${each.key} IQN Pool."
  iqn_prefix        = each.value.iqn_prefix
  iqn_suffix_blocks = each.value.iqn_suffix_blocks
  name              = each.key
  org_moid          = local.org_moids[each.value.organization].moid
  tags              = each.value.tags != [] ? each.value.tags : local.tags
}


#______________________________________________
#
# MAC Pools
#______________________________________________

module "mac_pools" {
  depends_on = [
    local.org_moids
  ]
  source           = "terraform-cisco-modules/imm/intersight//modules/pools_mac"
  for_each         = local.mac_pools
  assignment_order = each.value.assignment_order
  description      = each.value.description != "" ? each.value.description : "${each.value.organization} ${each.key} MAC Pool."
  mac_blocks       = each.value.mac_blocks
  name             = each.key
  org_moid         = local.org_moids[each.value.organization].moid
  tags             = each.value.tags != [] ? each.value.tags : local.tags
}


#______________________________________________
#
# UUID Pools
#______________________________________________

module "uuid_pools" {
  depends_on = [
    local.org_moids
  ]
  source             = "terraform-cisco-modules/imm/intersight//modules/pools_uuid"
  for_each           = local.uuid_pools
  assignment_order   = each.value.assignment_order
  description        = each.value.description != "" ? each.value.description : "${each.value.organization} ${each.key} UUID Pool."
  name               = each.key
  org_moid           = local.org_moids[each.value.organization].moid
  prefix             = each.value.prefix
  tags               = each.value.tags != [] ? each.value.tags : local.tags
  uuid_suffix_blocks = each.value.uuid_suffix_blocks
}

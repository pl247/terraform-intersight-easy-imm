#_________________________________________________________________________
#
# Intersight Local User Policies Variables
# GUI Location: Configure > Policies > Create Policy > Local User > Start
#_________________________________________________________________________

variable "local_user_password_1" {
  default     = ""
  description = "Password to assign to a local user.  Sensitive Variables cannot be added to a for_each loop so these are added seperately."
  sensitive   = true
  type        = string
}

variable "local_user_password_2" {
  default     = ""
  description = "Password to assign to a local user.  Sensitive Variables cannot be added to a for_each loop so these are added seperately."
  sensitive   = true
  type        = string
}

variable "local_user_password_3" {
  default     = ""
  description = "Password to assign to a local user.  Sensitive Variables cannot be added to a for_each loop so these are added seperately."
  sensitive   = true
  type        = string
}

variable "local_user_password_4" {
  default     = ""
  description = "Password to assign to a local user.  Sensitive Variables cannot be added to a for_each loop so these are added seperately."
  sensitive   = true
  type        = string
}

variable "local_user_password_5" {
  default     = ""
  description = "Password to assign to a local user.  Sensitive Variables cannot be added to a for_each loop so these are added seperately."
  sensitive   = true
  type        = string
}

variable "policy_local_users" {
  default = {
    default = {
      description             = ""
      enforce_strong_password = true
      force_send_password     = false
      grace_period            = 0
      users = {
        default = {
          enabled  = true
          password = 1
          role     = "admin"
        }
      }
      notification_period      = 15
      organization             = "default"
      password_expiry          = false
      password_expiry_duration = 90
      password_history         = 5
      tags                     = []
    }
  }
  description = <<-EOT
  key - Name of the Local User Policy.
  1. description - Description to Assign to the Policy.
  2. force_send_password - User password will always be sent to endpoint device. If the option is not selected, then user password will be sent to endpoint device for new users and if user password is changed for existing users.
  3. grace_period - Time period until when you can use the existing password, after it expires.
  4. users - Map of users to add to the local user policy.
    key - Username
    a. enabled - Enables the user account on the endpoint.
    b. password - This is a key to signify the variable "local_user_password_[key]" to be used.  i.e. 1 for variable "local_user_password_1".
    d. role - The Role to Assign to the User.  Valid Options are {admin|readonly|user}.
  5. notification_period - The duration after which the password will expire.
  6. organization - Name of the Intersight Organization to assign this Policy to.
    - https://intersight.com/an/settings/organizations/
  7. password_expiry - Enables password expiry on the endpoint.
  7. password_expiry_duration - Set time period for password expiration. Value should be greater than notification period and grace period.
  8. password_history - Tracks password change history. Specifies in number of instances, that the new password was already used.
  9. tags - List of Key/Value Pairs to Assign as Attributes to the Policy.
  EOT
  type = map(object(
    {
      description             = optional(string)
      enforce_strong_password = optional(bool)
      force_send_password     = optional(bool)
      grace_period            = optional(number)
      users = optional(map(object(
        {
          enabled  = optional(bool)
          password = optional(number)
          role     = optional(string)
        }
      )))
      notification_period      = optional(number)
      organization             = optional(string)
      password_expiry          = optional(bool)
      password_expiry_duration = optional(number)
      password_history         = optional(number)
      tags                     = optional(list(map(string)))
    }
  ))
}


#_________________________________________________________________________
#
# Local User Policies
# GUI Location: Configure > Policies > Create Policy > Local User > Start
#_________________________________________________________________________

module "policy_local_users" {
  depends_on = [
    local.org_moids,
    module.ucs_server_profile
  ]
  source                   = "terraform-cisco-modules/imm/intersight//modules/policies_local_user_policy"
  for_each                 = local.policy_local_users
  description              = each.value.description != "" ? each.value.description : "${each.key} Local User Policy."
  enable_password_expiry   = each.value.password_expiry
  enforce_strong_password  = each.value.enforce_strong_password
  force_send_password      = each.value.force_send_password
  grace_period             = each.value.grace_period
  name                     = each.key
  notification_period      = each.value.notification_period
  org_moid                 = local.org_moids[each.value.organization].moid
  password_expiry_duration = each.value.password_expiry_duration
  password_history         = each.value.password_history
  profiles = [for s in sort(keys(
  local.ucs_server_profiles)) : module.ucs_server_profile[s].moid if local.ucs_server_profiles[s].policy_local_users == each.key]
  tags = each.value.tags != [] ? each.value.tags : local.tags
}


#_________________________________________________________________________
#
# Local Users
# GUI Location: Configure > Policies > Create Policy > Local User > Start
#_________________________________________________________________________

module "local_users" {
  depends_on = [
    local.org_moids,
    module.policy_local_users
  ]
  for_each         = local.local_users.users
  source           = "terraform-cisco-modules/imm/intersight//modules/policies_local_user"
  org_moid         = local.org_moids[each.value.organization].moid
  user_enabled     = each.value.enabled
  user_password    = each.value.password == 1 ? var.local_user_password_1 : each.value.password == 2 ? var.local_user_password_1 : each.value.password == 3 ? var.local_user_password_1 : each.value.password == 4 ? var.local_user_password_1 : var.local_user_password_1
  user_policy_moid = module.policy_local_users[each.value.policy].moid
  user_role        = each.value.role
  username         = each.value.username
}
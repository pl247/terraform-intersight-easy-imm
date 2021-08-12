#_________________________________________________________________________
#
# Intersight SMTP Policies Variables
# GUI Location: Configure > Policies > Create Policy > SMTP > Start
#_________________________________________________________________________

variable "policy_smtp" {
  default = {
    default = {
      description     = ""
      enabled         = true
      min_severity    = "critical"
      organization    = "default"
      sender_email    = ""
      smtp_port       = 25
      smtp_recipients = []
      smtp_server     = ""
      tags            = []
    }
  }
  description = <<-EOT
  key - Name of the SMTP Policy.
  1. description - Description to Assign to the Policy.
  2. enabled - If enabled, controls the state of the SMTP client service on the managed device.
  3. min_severity - Minimum fault severity level to receive email notifications. Email notifications are sent for all faults whose severity is equal to or greater than the chosen level.
    * critical - Minimum severity to report is critical.
    * condition - Minimum severity to report is informational.
    * warning - Minimum severity to report is warning.
    * minor - Minimum severity to report is minor.
    * major - Minimum severity to report is major.
  4. organization - Name of the Intersight Organization to assign this Policy to.
    - https://intersight.com/an/settings/organizations/
  5. sender_email - The email address entered here will be displayed as the from address (mail received from address) of all the SMTP mail alerts that are received. If not configured, the hostname of the server is used in the from address field.
  6. smtp_port - Port number used by the SMTP server for outgoing SMTP communication.  Valid range is between 1-65535.
  7. smtp_recipients - List of Emails to send alerts to.
  8. smtp_server - IP address or hostname of the SMTP server. The SMTP server is used by the managed device to send email notifications.
  9. tags - List of Key/Value Pairs to Assign as Attributes to the Policy.
  EOT
  type = map(object(
    {
      description     = optional(string)
      enabled         = optional(bool)
      min_severity    = optional(string)
      organization    = optional(string)
      sender_email    = optional(string)
      smtp_port       = optional(number)
      smtp_recipients = optional(list(string))
      smtp_server     = optional(string)
      tags            = optional(list(map(string)))
    }
  ))
}


#____________________________________________________________
#
# SMTP Policy
# GUI Location: Policies > Create Policy > SMTP
#____________________________________________________________

module "smtp" {
  depends_on = [
    local.org_moids,
    module.ucs_server_profile
  ]
  source       = "terraform-cisco-modules/imm/intersight//modules/policies_smtp"
  for_each     = local.policy_smtp
  description  = each.value.description != "" ? each.value.description : "${each.key} SMTP Policy."
  enabled      = each.value.enabled
  min_severity = each.value.min_severity
  name         = each.key
  org_moid     = local.org_moids[each.value.organization].moid
  profiles = [for s in sort(keys(
  local.ucs_server_profiles)) : module.ucs_server_profile[s].moid if local.ucs_server_profiles[s].policy_smtp == each.key]
  sender_email    = each.value.sender_email != "" ? each.value.sender_email : each.value.smtp_server
  smtp_recipients = each.value.smtp_recipients
  smtp_server     = each.value.smtp_server
  tags            = each.value.tags != [] ? each.value.tags : local.tags
}


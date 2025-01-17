terraform {
  experiments = [module_variable_optional_attrs]
}

#__________________________________________________________
#
# Terraform Cloud Variables
#__________________________________________________________

variable "terraform_cloud_token" {
  description = "Token to Authenticate to the Terraform Cloud."
  sensitive   = true
  type        = string
}

variable "tfc_oauth_token" {
  description = "Terraform Cloud OAuth Token for VCS_Repo Integration."
  sensitive   = true
  type        = string
}

variable "tfc_organization" {
  description = "Terraform Cloud Organization Name."
  type        = string
}

variable "terraform_version" {
  default     = "1.0.3"
  description = "Terraform Target Version."
  type        = string
}

variable "vcs_repo" {
  description = "Version Control System Repository."
  type        = string
}


#__________________________________________________________
#
# Intersight Sensitive Variables
#__________________________________________________________

variable "apikey" {
  description = "Intersight API Key."
  sensitive   = true
  type        = string
}

variable "secretkey" {
  description = "Intersight Secret Key."
  sensitive   = true
  type        = string
}


#__________________________________________________________
#
# IPMI over LAN Sensitive Variable
#__________________________________________________________

variable "ipmi_key_1" {
  default     = ""
  description = "Encryption key to use for IPMI communication. It should have an even number of hexadecimal characters and not exceed 40 characters."
  sensitive   = true
  type        = string
}


#__________________________________________________________
#
# LDAP Policy Sensitive Variable
#__________________________________________________________

variable "ldap_password" {
  default     = ""
  description = "The password of the user for initial bind process. It can be any string that adheres to the following constraints. It can have character except spaces, tabs, line breaks. It cannot be more than 254 characters."
  sensitive   = true
  type        = string
}


#__________________________________________________________
#
# Local User Policy Sensitive Variables
#__________________________________________________________

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


#__________________________________________________________
#
# Persistent Memory Policy Sensitive Variables
#__________________________________________________________

variable "persistent_passphrase" {
  default     = ""
  description = "Secure passphrase to be applied on the Persistent Memory Modules on the server. The allowed characters are a-z, A to Z, 0-9, and special characters =, \u0021, &, #, $, %, +, ^, @, _, *, -."
  sensitive   = true
  type        = string
}

#__________________________________________________________
#
# SNMP Policy Sensitive Variables
#__________________________________________________________

variable "snmp_community" {
  default     = ""
  description = "The default SNMPv1, SNMPv2c community name or SNMPv3 username to include on any trap messages sent to the SNMP host. The name can be 18 characters long."
  sensitive   = true
  type        = string
}

variable "snmp_trap_community" {
  default     = ""
  description = "The default SNMPv1, SNMPv2c community name or SNMPv3 username to include on any trap messages sent to the SNMP host. The name can be 18 characters long."
  sensitive   = true
  type        = string
}

variable "snmp_user_1_auth_password" {
  default     = ""
  description = "Authorization password for the user."
  sensitive   = true
  type        = string
}

variable "snmp_user_1_privacy_password" {
  default     = ""
  description = "Privacy password for the user."
  sensitive   = true
  type        = string
}

variable "snmp_user_2_auth_password" {
  default     = ""
  description = "Authorization password for the user."
  sensitive   = true
  type        = string
}

variable "snmp_user_2_privacy_password" {
  default     = ""
  description = "Privacy password for the user."
  sensitive   = true
  type        = string
}

variable "workspaces" {
  default = {
    default = {
      auto_apply        = true
      description       = ""
      working_directory = "modules/pools"
      workspace_type    = "pool"
    }
  }
  description = <<-EOT
  Map of Workspaces to create in Terraform Cloud.
  key - Name of the Workspace to Create.
  * description - A Description for the Workspace.
  * working_directory - The Directory of the Version Control Repository that contains the Terraform code for UCS Domain Profiles for this Workspace.
  * workspace_type - What Type of Workspace will this Create.  Options are:
    - chassis
    - domain
    - pool
    - server
    - vlan
  EOT
  type = map(object(
    {
      auto_apply        = optional(bool)
      description       = optional(string)
      working_directory = optional(string)
      workspace_type    = optional(string)
    }
  ))
}

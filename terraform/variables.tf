variable "resource_group_name" {
    type = string
    default = ""
}

variable "project" {
    type = string
    default = "streamlit-ad"
}

variable "ARM_TENANT_ID" {
    type = string
    default = ""
  
}

variable "location" {
  type        = string
  description = "Default location of West Europe"
  default     = "West Europe"
}

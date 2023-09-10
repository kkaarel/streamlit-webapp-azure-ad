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


variable "storage_account_name" {}
variable "container_name" {}
variable "storage_blob_name" {}


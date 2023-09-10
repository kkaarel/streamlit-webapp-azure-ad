variable "RESOURCE_GROUP_NAME" {
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


variable "STORAGE_ACCOUNT_NAME" {}
variable "CONTAINER_NAME" {}
variable "STORAGE_BLOB_NAME" {}


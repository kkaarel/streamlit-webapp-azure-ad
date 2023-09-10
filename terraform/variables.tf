variable "RESOURCE_GROUP_NAME" {
}

variable "project" {
  type    = string
  default = "streamlit-ad"
}

variable "ARM_TENANT_ID" {

}

variable "location" {
  type        = string
  description = "Default location of West Europe"
  default     = "West Europe"
}

variable "storage_account_bame" {
  
}

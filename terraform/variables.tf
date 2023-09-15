variable "RESOURCE_GROUP_NAME" {
    type = string
    default = ""
}

variable "project" {
  type    = string
  default = "streamlit-adintegration"
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

variable "STORAGE_ACCOUNT_NAME" {
    type = string
    default = ""
}

variable "client_id_ad" {
    type = string
    default = ""
  
}


variable "archive_file_streamlit" {
  type = string
  default = "./streamlit/streamlit.zip"
  
}


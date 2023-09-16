variable "RESOURCE_GROUP_NAME" {
    type = string

}

variable "project" {
  type    = string
  default = "streamlit-adintegration"
}

variable "ARM_TENANT_ID" {
    type = string

}

variable "location" {
  type        = string
  description = "Default location of West Europe"
  default     = "West Europe"
}

variable "STORAGE_ACCOUNT_NAME" {
    type = string

}

variable "client_id_ad" {
    type = string

  
}


variable "archive_file_streamlit" {
  type = string
  default = "./streamlit/streamlit.zip"
  
}


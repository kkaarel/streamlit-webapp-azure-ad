variable "RESOURCE_GROUP_NAME" {
    type = string
    default = "kkaarel_dev001"

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

variable "CLIENT_ID_AD" {
    type = string


  
}

variable "key" {
    type = string
 
  
}

variable "archive_file_streamlit" {
  type = string
  default = "./streamlit/streamlit.zip"
  
}


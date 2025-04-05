variable "backend_resource_group_name" {
  description = "Resource group for the backend storage account."
  type        = string
}

variable "backend_storage_account_name" {
  description = "Storage account for backend state."
  type        = string
}

variable "backend_container_name" {
  description = "Container name inside storage account for the state file."
  type        = string
}

variable "backend_key" {
  description = "The key for the backend state file"
  type        = string
}

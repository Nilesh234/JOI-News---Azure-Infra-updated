variable "location" {
  description = "Azure region to deploy resources."
  type        = string
  default     = "East US"
}

variable "resource_group_name" {
  description = "Name of the resource group."
  type        = string
}

variable "acr_name" {
  description = "Azure Container Registry name."
  type        = string
}

variable "vnet_name" {
  description = "Virtual Network name."
  type        = string
}

variable "subnet_name" {
  description = "Subnet name."
  type        = string
}

variable "storage_account_name" {
  description = "Storage account name."
  type        = string
}

variable "allowed_ip" {
  description = "Allowed IP address for SSH access."
  type        = string
  default     = "MY_PUBLIC_IP/32"
  
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
}
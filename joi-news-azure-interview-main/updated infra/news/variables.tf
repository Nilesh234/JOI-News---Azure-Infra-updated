variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group name"
  type        = string
}

variable "vnet_name" {
  description = "VNet name"
  type        = string
}

variable "subnet_name" {
  description = "Subnet name"
  type        = string
}

variable "acr_name" {
  description = "Azure Container Registry name"
  type        = string
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
  
}

variable "acr_url_default" {
  description = "Default URL for Azure Container Registry"
  type        = string
}
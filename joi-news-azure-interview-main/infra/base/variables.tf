variable "prefix" {
  default = "news4321"
}

variable "location" {
  default = "East US"
}

variable "allowed_ip" {
  description = "Allowed IP address for SSH access"
  type        = string
  default     = "MY_PUBLIC_IP/32"
}

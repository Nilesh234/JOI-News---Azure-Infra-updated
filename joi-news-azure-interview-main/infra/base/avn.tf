
variable "location" {
  description = "The Azure location where the resources will be created."
  type        = string
  default     = "East US"
  
}

data "azurerm_resource_group" "azure-resource" {
  name = "azure-resource-group"
}

resource "azurerm_virtual_network" "virtual-network" {
  name                = "virtual-network"
  resource_group_name = data.azurerm_resource_group.azure-resource.name
  location            = var.location
  address_space       = ["10.5.0.0/16"]

  tags = {
    environment = "Production"
  }
}

resource "azurerm_subnet" "public_subnet_a" {
  name                 = "public_subnet_a"
  resource_group_name  = data.azurerm_resource_group.azure-resource.name
  virtual_network_name = azurerm_virtual_network.virtual-network.name
  address_prefixes     = ["10.5.0.0/24"]
}

resource "azurerm_subnet" "public_subnet_b" {
  name                 = "public_subnet_b"
  resource_group_name  = data.azurerm_resource_group.azure-resource.name
  virtual_network_name = azurerm_virtual_network.virtual-network.name
  address_prefixes     = ["10.5.1.0/24"]
}

resource "azurerm_public_ip" "public-ip-quotes" {
  name                = "public-ip-quotes"
  resource_group_name = data.azurerm_resource_group.azure-resource.name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_public_ip" "public-ip-newsfeed" {
  name                = "public-ip-newsfeed"
  resource_group_name = data.azurerm_resource_group.azure-resource.name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_public_ip" "public-ip-frontend" {
  name                = "public-ip-frontend"
  resource_group_name = data.azurerm_resource_group.azure-resource.name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Routing table for public subnets
resource "azurerm_route_table" "route-table" {
  name                          = "route-table"
  location                      = var.location
  resource_group_name           = data.azurerm_resource_group.azure-resource.name
  #disable_bgp_route_propagation = false

  route {
    name           = "route"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "Internet"
  }

  tags = {
    environment = "Production"
  }
}

# Associate the routing table to public subnet A
resource "azurerm_subnet_route_table_association" "association-subnet-a" {
  subnet_id      = azurerm_subnet.public_subnet_a.id
  route_table_id = azurerm_route_table.route-table.id
}

# Associate the routing table to public subnet B
resource "azurerm_subnet_route_table_association" "association-subnet-b" {
  subnet_id      = azurerm_subnet.public_subnet_b.id
  route_table_id = azurerm_route_table.route-table.id
}

#NSG
resource "azurerm_network_security_group" "security-group-quotes" {
  name                = "security-group-quotes"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.azure-resource.name
  security_rule {
    name                       = "allow-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "YOUR_IP_ADDRESS_HERE"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "allow-app-port"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8082"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "security-group-newsfeed" {
  name                = "security-group-newsfeed"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.azure-resource.name

  security_rule {
    name                       = "allow-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "YOUR_IP_ADDRESS_HERE"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-app-port"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8081"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "security-group-frontend" {
  name                = "security-group-frontend"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.azure-resource.name
  security_rule {
    name                       = "allow-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "YOUR_IP_ADDRESS_HERE"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-app-port"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "association-ni-sg-quotes" {
  network_interface_id      = azurerm_network_interface.network-interface-quotes.id
  network_security_group_id = azurerm_network_security_group.security-group-quotes.id
}

resource "azurerm_network_interface_security_group_association" "association-ni-sg-newsfeed" {
  network_interface_id      = azurerm_network_interface.network-interface-newsfeed.id
  network_security_group_id = azurerm_network_security_group.security-group-newsfeed.id
}

resource "azurerm_network_interface_security_group_association" "association-ni-sg-frontend" {
  network_interface_id      = azurerm_network_interface.network-interface-frontend.id
  network_security_group_id = azurerm_network_security_group.security-group-frontend.id
}

resource "azurerm_network_interface" "quotes" {
  name                = "nic-quotes"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.azure_resource.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.public_a.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.quotes.id
  }
}
#NIC
resource "azurerm_network_interface" "newsfeed" {
  name                = "nic-newsfeed"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.azure_resource.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.public_a.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.newsfeed.id
  }
}

resource "azurerm_network_interface" "frontend" {
  name                = "nic-frontend"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.azure_resource.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.public_b.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.frontend.id
  }
}
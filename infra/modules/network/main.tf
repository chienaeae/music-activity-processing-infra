resource "azurerm_virtual_network" "main" {
  name                = "${var.resource_prefix}-vnet"
  address_space       = [var.address_space]
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# Create AKS subnet
resource "azurerm_subnet" "aks" {
  name                 = "${var.resource_prefix}-aks-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.aks_subnet_cidr]
  
  # This service endpoint allows AKS cluster to communicate with ACR
  service_endpoints    = ["Microsoft.ContainerRegistry"]
}

# Create database subnet
resource "azurerm_subnet" "db" {
  name                 = "${var.resource_prefix}-db-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.db_subnet_cidr]
  
  # Service endpoint allows database service connection
  service_endpoints    = ["Microsoft.Sql"]
}

# AKS NSG
resource "azurerm_network_security_group" "aks" {
  name                = "${var.resource_prefix}-aks-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  # Allow HTTP inbound traffic
  security_rule {
    name                       = "AllowHTTPInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Allow HTTPS inbound traffic
  security_rule {
    name                       = "AllowHTTPSInbound"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Database NSG
resource "azurerm_network_security_group" "db" {
  name                = "${var.resource_prefix}-db-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  # Allow SQL Server traffic from AKS subnet inbound
  security_rule {
    name                       = "AllowSQLFromAKS"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1433"  # SQL Server port
    source_address_prefix      = var.aks_subnet_cidr
    destination_address_prefix = "*"
  }
}

# Associate NSG with subnet
resource "azurerm_subnet_network_security_group_association" "aks" {
  subnet_id                 = azurerm_subnet.aks.id
  network_security_group_id = azurerm_network_security_group.aks.id
}

resource "azurerm_subnet_network_security_group_association" "db" {
  subnet_id                 = azurerm_subnet.db.id
  network_security_group_id = azurerm_network_security_group.db.id
} 
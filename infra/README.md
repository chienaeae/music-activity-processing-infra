# Infrastructure Layer (Infra)

This directory contains the Terraform configuration for Azure infrastructure resources, responsible for creating all necessary cloud resources such as AKS clusters, ACR, SQL databases, and network components.

## Directory Structure

```
infra/
├── main.tf              # Main configuration file
├── variables.tf         # Variable definitions
├── outputs.tf           # Output definitions, including AKS credentials
├── resources.tf         # Azure resource configuration
├── modules/             # Reusable Terraform modules
│   ├── network/         # Network module
│   ├── aks/             # AKS cluster module
│   ├── acr/             # Container registry module
│   └── database/        # SQL database module
└── environments/        # Environment-specific configurations
    ├── dev/             # Development environment
    └── test/            # Test environment
```

## Features

- Create Azure resource group
- Deploy virtual network and subnets
- Deploy Azure Kubernetes Service (AKS) cluster
- Deploy Azure Container Registry (ACR)
- Deploy Azure SQL Database
- Configure network security and access control

## Usage

Initialize and apply from environment directory:

```bash
# Development environment
cd environments/dev
terraform init
terraform apply -var="sql_admin_password=<your-password>"

# Test environment
cd environments/test
terraform init
terraform apply -var="sql_admin_password=<your-password>"
```

## Outputs

infra layer provides the following key outputs, which will be used for k8s layer configuration:

- AKS cluster credentials (host, client_certificate, client_key, cluster_ca_certificate)
- AKS cluster name and ID
- ACR login information
- SQL database connection information
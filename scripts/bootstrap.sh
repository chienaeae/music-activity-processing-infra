#!/bin/bash
# Script to initialize Terraform backend and update environment configurations

# Define colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Initializing Terraform...${NC}"
cd bootstrap

# Initialize and apply bootstrap configuration
echo -e "${YELLOW}Running terraform init...${NC}"
terraform init

echo -e "${YELLOW}Running terraform apply...${NC}"
terraform apply -auto-approve

# Extract outputs
RESOURCE_GROUP=$(terraform output -raw resource_group_name)
STORAGE_ACCOUNT=$(terraform output -raw storage_account_name)
CONTAINER=$(terraform output -raw container_name)
BACKEND_TEMPLATE=$(terraform output backend_config_template)

# Return to root directory
cd ..

# Update environment configurations
echo -e "${YELLOW}Updating environment configuration files...${NC}"

# ======= Infrastructure layer (infra) configuration =======

# Update infra/dev environment
INFRA_DEV_BACKEND="terraform {
  backend \"azurerm\" {
    resource_group_name  = \"$RESOURCE_GROUP\"
    storage_account_name = \"$STORAGE_ACCOUNT\"
    container_name       = \"$CONTAINER\"
    key                  = \"infra-dev.terraform.tfstate\"
  }
}"

echo -e "${YELLOW}Updating infra/dev environment backend.tf...${NC}"
echo "$INFRA_DEV_BACKEND" > infra/environments/dev/backend.tf

# Update infra/test environment
INFRA_TEST_BACKEND="terraform {
  backend \"azurerm\" {
    resource_group_name  = \"$RESOURCE_GROUP\"
    storage_account_name = \"$STORAGE_ACCOUNT\"
    container_name       = \"$CONTAINER\"
    key                  = \"infra-test.terraform.tfstate\"
  }
}"

echo -e "${YELLOW}Updating infra/test environment backend.tf...${NC}"
echo "$INFRA_TEST_BACKEND" > infra/environments/test/backend.tf

# ======= Kubernetes layer (k8s) configuration =======

# Update k8s/dev environment
K8S_DEV_BACKEND="terraform {
  backend \"azurerm\" {
    resource_group_name  = \"$RESOURCE_GROUP\"
    storage_account_name = \"$STORAGE_ACCOUNT\"
    container_name       = \"$CONTAINER\"
    key                  = \"k8s-dev.terraform.tfstate\"
  }
}"

echo -e "${YELLOW}Updating k8s/dev environment backend.tf...${NC}"
echo "$K8S_DEV_BACKEND" > k8s/environments/dev/backend.tf

# Update k8s/test environment
K8S_TEST_BACKEND="terraform {
  backend \"azurerm\" {
    resource_group_name  = \"$RESOURCE_GROUP\"
    storage_account_name = \"$STORAGE_ACCOUNT\"
    container_name       = \"$CONTAINER\"
    key                  = \"k8s-test.terraform.tfstate\"
  }
}"

echo -e "${YELLOW}Updating k8s/test environment backend.tf...${NC}"
echo "$K8S_TEST_BACKEND" > k8s/environments/test/backend.tf

echo -e "${GREEN}Backend initialization complete!${NC}"
echo -e "${GREEN}Resource group: $RESOURCE_GROUP${NC}"
echo -e "${GREEN}Storage account: $STORAGE_ACCOUNT${NC}"
echo -e "${GREEN}Container name: $CONTAINER${NC}"
echo -e "${YELLOW}Now you can use 'terraform init' to initialize each environment with the remote backend.${NC}" 
#!/bin/bash
# Complete infrastructure destruction script from k8s to infra
# How to run: ./scripts/destroy.sh <environment> <sql_password>
# Example: ./scripts/destroy.sh dev Test12345!

# Define colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Set error handling
set -e
trap 'echo -e "${RED}Script execution failed${NC}"; exit 1' ERR

# Parameter check
if [ -z "$1" ]; then
  echo -e "${RED}Error: Please provide the environment name (dev or test)${NC}"
  echo "Usage: $0 <environment> [SQL password]"
  exit 1
fi

ENVIRONMENT=$1
SQL_PASSWORD=${2:-"Test12345!"}  # Default password, should use a more secure method in production

echo -e "${YELLOW}Starting destruction for environment: ${ENVIRONMENT}${NC}"

# Step 1: Get AKS credentials
echo -e "${YELLOW}Step 1: Getting AKS credentials...${NC}"
cd infra/environments/${ENVIRONMENT}

# Get resource group and AKS cluster name
RESOURCE_GROUP="event-proc-${ENVIRONMENT}-rg"
AKS_CLUSTER_NAME="event-proc-${ENVIRONMENT}-aks"

# Initialize Terraform
echo -e "${YELLOW}Initializing Terraform...${NC}"
terraform init -reconfigure

# Refresh state to ensure output is up to date
echo -e "${YELLOW}Refreshing Terraform state...${NC}"
if terraform refresh -var="sql_admin_password=${SQL_PASSWORD}" &>/dev/null; then
  echo -e "${YELLOW}State refresh successful${NC}"
else
  echo -e "${YELLOW}Failed to refresh state, this may indicate resources do not exist${NC}"
fi

# Try to get AKS credentials using Azure CLI
echo -e "${YELLOW}Trying to get AKS credentials using Azure CLI...${NC}"
CREDS_AVAILABLE=false

if az aks get-credentials --resource-group ${RESOURCE_GROUP} --name ${AKS_CLUSTER_NAME} --overwrite-existing &>/dev/null; then
  CREDS_AVAILABLE=true
  echo -e "${GREEN}Successfully got AKS credentials${NC}"
else
  echo -e "${YELLOW}Failed to get AKS credentials, possibly AKS cluster does not exist or has been destroyed${NC}"
fi

# Step 2: Destroy Kubernetes layer (k8s) - if credentials are available
if [ "$CREDS_AVAILABLE" = true ]; then
  echo -e "${YELLOW}Step 2: Destroying Kubernetes layer...${NC}"
  cd ../../../k8s/environments/${ENVIRONMENT}
  
  echo -e "${YELLOW}Initializing Terraform...${NC}"
  terraform init -reconfigure
  
  echo -e "${YELLOW}Destroying Kubernetes resources...${NC}"
  terraform destroy -auto-approve
  
  cd ../../../
else
  echo -e "${YELLOW}Skipping Kubernetes layer destruction, directly destroying infrastructure layer${NC}"
fi

# Step 3: Destroy infrastructure layer (infra)
echo -e "${YELLOW}Step 3: Destroying infrastructure layer...${NC}"
cd infra/environments/${ENVIRONMENT}

echo -e "${YELLOW}Destroying infrastructure resources...${NC}"
terraform destroy -auto-approve -var="sql_admin_password=${SQL_PASSWORD}"

# Return to project root
cd ../../../

# Completion information
echo -e "${GREEN}====================================${NC}"
echo -e "${GREEN}✅ Destruction completed! Environment: ${ENVIRONMENT}${NC}"
echo -e "${GREEN}====================================${NC}"

# Note: We do not destroy bootstrap resources, as they may be used by other environments
echo -e "${YELLOW}Note: Remote state storage (bootstrap) resources were not destroyed${NC}"
echo -e "${YELLOW}If you need to destroy these resources, please run manually:${NC}"
echo -e "cd bootstrap && terraform destroy" 
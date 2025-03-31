#!/bin/bash
# Complete infrastructure deployment script from bootstrap to infra to k8s
# How to run: ./scripts/apply.sh <environment> <sql_password>
# Example: ./scripts/apply.sh dev Test12345!

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

echo -e "${YELLOW}Starting deployment for environment: ${ENVIRONMENT}${NC}"

# Step 0: Run bootstrap to initialize remote state storage
echo -e "${YELLOW}Step 0: Initializing remote state storage...${NC}"
./scripts/bootstrap.sh

# Step 1: Deploy infrastructure layer (infra)
echo -e "${YELLOW}Step 1: Deploying infrastructure layer...${NC}"
cd infra/environments/${ENVIRONMENT}

echo -e "${YELLOW}Initializing Terraform...${NC}"
terraform init -reconfigure

echo -e "${YELLOW}Applying infrastructure configuration...${NC}"
terraform apply -auto-approve -var="sql_admin_password=${SQL_PASSWORD}"

# Check if infra layer is deployed successfully and refresh to ensure latest output
echo -e "${YELLOW}Refreshing Terraform state...${NC}"
terraform refresh -var="sql_admin_password=${SQL_PASSWORD}"

# Get resource group and AKS cluster name
RESOURCE_GROUP="event-proc-${ENVIRONMENT}-rg"
AKS_CLUSTER_NAME="event-proc-${ENVIRONMENT}-aks"

# Use az command directly to get AKS credentials
echo -e "${YELLOW}Using Azure CLI to get AKS credentials...${NC}"
if ! az aks get-credentials --resource-group ${RESOURCE_GROUP} --name ${AKS_CLUSTER_NAME} --overwrite-existing; then
  echo -e "${RED}Error: Failed to get AKS credentials using Azure CLI, please ensure you are logged in Azure and the resources are deployed correctly${NC}"
  exit 1
fi

echo -e "${GREEN}Successfully got AKS credentials${NC}"

# Check if the current context is set correctly
CURRENT_CONTEXT=$(kubectl config current-context 2>/dev/null || echo "")
if [[ ! "$CURRENT_CONTEXT" == *"${AKS_CLUSTER_NAME}"* ]]; then
  echo -e "${RED}Error: kubectl context is not set to the newly deployed AKS cluster${NC}"
  exit 1
fi

echo -e "${GREEN}kubectl is correctly configured to use the ${AKS_CLUSTER_NAME} cluster${NC}"

# Verify the context name used in k8s configuration matches the actual context
K8S_CONTEXT_NAME="event-proc-${ENVIRONMENT}-aks"
if [[ "$CURRENT_CONTEXT" != *"$K8S_CONTEXT_NAME"* ]]; then
  echo -e "${YELLOW}Warning: The current kubectl context name '$CURRENT_CONTEXT' does not match the '$K8S_CONTEXT_NAME' used in the Terraform configuration${NC}"
  echo -e "${YELLOW}Update the k8s_context_name value in k8s/environments/${ENVIRONMENT}/main.tf...${NC}"
  # Do not modify the file, but remind the user of this potential issue
fi

# Step 2: Deploy Kubernetes layer (k8s)
echo -e "${YELLOW}Step 2: Deploying Kubernetes layer...${NC}"
cd ../../../k8s/environments/${ENVIRONMENT}

echo -e "${YELLOW}Initializing Terraform...${NC}"
terraform init -reconfigure

echo -e "${YELLOW}Applying Kubernetes configuration...${NC}"

# Use kubectl directly to configure, not through variables
terraform apply -auto-approve

# Return to project root
cd ../../../

# Completion information
echo -e "${GREEN}====================================${NC}"
echo -e "${GREEN}✅ Deployment completed! Environment: ${ENVIRONMENT}${NC}"
echo -e "${GREEN}====================================${NC}"

# Display ArgoCD access information
echo -e "${YELLOW}Getting ArgoCD access information...${NC}"
cd k8s/environments/${ENVIRONMENT}
ARGOCD_NAMESPACE=$(terraform output -raw argocd_namespace 2>/dev/null || echo "argocd")
# Get password command
PASSWORD_CMD=$(terraform output -raw argocd_admin_password_command 2>/dev/null || echo "kubectl -n ${ARGOCD_NAMESPACE} get secret argocd-initial-admin-secret -o jsonpath=\"{.data.password}\" | base64 -d")
cd ../../../

echo -e "${GREEN}ArgoCD access instructions:${NC}"
echo -e "1. Get ArgoCD admin password:"
echo -e "   ${PASSWORD_CMD}"
echo -e "2. Get ArgoCD server information:"
echo -e "   kubectl get svc argocd-server -n ${ARGOCD_NAMESPACE}"
echo -e "3. Use browser to access:"
echo -e "   http://<ARGOCD_SERVER_IP> (recommended, avoid certificate warnings)"
echo -e "   or https://<ARGOCD_SERVER_IP> (certificate warnings will appear)"
echo -e "4. Use credentials to login:"
echo -e "   Username: admin"
echo -e "   Password: random password obtained from step 1"
echo -e "   Important: Please change the password after the first login (via the user menu in the top right corner of the ArgoCD interface)"
echo -e "${GREEN}====================================${NC}" 
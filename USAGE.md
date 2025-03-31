# Usage Instructions - Two-stage Terraform deployment process

This project implements a two-stage Terraform deployment strategy, separating the infrastructure layer (infra) from the Kubernetes layer (k8s), making the architecture more modular and maintainable.

## Initial Setup

First, initialize the remote state storage backend:

```bash
# Run the bootstrap script to set up the remote state storage backend
./scripts/bootstrap.sh
```

## 1. Deploy the infrastructure layer (infra)

First, deploy the Azure infrastructure:

```bash
# Development environment
cd infra/environments/dev
terraform init
terraform apply -var="sql_admin_password=<your-password>"

# Test environment
cd infra/environments/test
terraform init
terraform apply -var="sql_admin_password=<your-password>"
```

## 2. Get AKS credentials

Use Azure CLI to get AKS credentials:

```bash
# Configure kubectl to connect to the AKS cluster
az aks get-credentials --resource-group event-proc-dev-rg --name event-proc-dev-aks --overwrite-existing
```

## 3. Deploy the Kubernetes layer (k8s)

After getting the AKS credentials, deploy the k8s layer:

```bash
# Development environment
cd k8s/environments/dev
terraform init
terraform apply

# Test environment
cd ../test
terraform init
terraform apply
```

## Use the automation script

To simplify the deployment process, you can use the scripts provided in the project:

```bash
# Full deployment (bootstrap + infra + k8s)
./scripts/apply.sh dev [sql_password]

# Destroy all resources (k8s → infra)
./scripts/destroy.sh dev [sql_password]
```

## Access ArgoCD

After deployment, you can access ArgoCD by following the steps below:

```bash
# Get ArgoCD password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

# Get ArgoCD service information
kubectl get svc argocd-server -n argocd

# Use a browser to access:
# http://<ARGOCD_SERVER_IP> (recommended, avoids certificate warnings)
# https://<ARGOCD_SERVER_IP> (certificate warnings will appear)

# Login credentials:
# Username: admin
# Password: random password obtained from the above command
```

**Important Note**: Please change the default password after the first login (via the user menu in the top right corner of the ArgoCD interface).

## Resource Destruction

When destroying, follow the reverse order of creation:

```bash
# 1. Destroy k8s layer resources first
cd k8s/environments/dev
terraform destroy

# 2. Destroy infra layer resources
cd ../../infra/environments/dev
terraform destroy -var="sql_admin_password=<your-password>"
```

## Benefits

Two-stage deployment strategy provides the following benefits:

1. **Separation of concerns**：infrastructure and application concerns are separated
2. **Maintainability**：each layer can be updated and maintained separately
3. **Flexibility**：infra layer can be reused with different k8s configurations
4. **Risk reduction**：running `terraform plan` does not affect the entire system
5. **Better GitOps practices**：application configuration managed in an external Git repository through Argo CD

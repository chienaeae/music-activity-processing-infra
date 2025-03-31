# Kubernetes Layer (K8s)

This directory contains the Terraform configuration for the Kubernetes layer, responsible for managing the Kubernetes environment, installing ArgoCD, and configuring application deployments.

## Directory Structure

```
k8s/
├── main.tf              # Main configuration file
├── variables.tf         # Variable definitions
├── outputs.tf           # Output definitions
├── argocd/              # ArgoCD module
└── helm_charts/         # (Optional) Helm charts
```

## Features

- Configure the Kubernetes Provider
- Deploy ArgoCD (using Helm)
- Set up basic GitOps configuration

## Prerequisites

Before applying this configuration, you must first complete the deployment of the infra layer, as the k8s layer depends on the AKS cluster created by the infra layer.

## Usage

1. Apply the infra configuration:
```bash
cd infra/environments/dev
terraform init
terraform apply -var="sql_admin_password=<your-password>"
```

2. Get AKS credentials:
```bash
az aks get-credentials --resource-group event-proc-dev-rg --name event-proc-dev-aks --overwrite-existing
```

3. Apply the k8s configuration:
```bash
cd ../../k8s/environments/dev
terraform init
terraform apply
```

## GitOps Workflow

1. Infrastructure layer (infra/) deploys the AKS cluster and all Azure resources
2. Kubernetes layer (k8s/) deploys ArgoCD and sets up basic GitOps configuration
3. Application configuration and deployment is managed through external Git repositories:
   - GitHub: https://github.com/chienaeae/music-activity-processing-system
   - All Kubernetes manifest files are stored in the apps/applications/ directory in this repository

## Access ArgoCD

After deployment, you can access the ArgoCD interface using the following steps:

1. Get ArgoCD password:
```bash
# Method 1: Use Terraform output
terraform output argocd_admin_password_command

# Method 2: Execute the command directly
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

2. Get the external IP of the ArgoCD service:
```bash
kubectl get svc argocd-server -n argocd
```

3. Access using a browser:
```
# Recommended to use HTTP to avoid certificate warnings
http://<ARGOCD_SERVER_IP>

# Alternatively, access using HTTPS (certificate warnings will appear)
https://<ARGOCD_SERVER_IP>
```

4. Use credentials to login:
   - Username: admin
   - Password: Get from step 1 (randomly generated password)
   - **Important Note**: Please change the password after the first login (via the user menu in the top right corner of the ArgoCD interface)

## Password Management

- ArgoCD uses a randomly generated initial password, stored in the `argocd-initial-admin-secret` Secret
- After the first login, it is strongly recommended to change the default password (via the user menu in the top right corner of the ArgoCD interface)
- If the password is forgotten, it can be reset by re-deploying ArgoCD or modifying the Secret
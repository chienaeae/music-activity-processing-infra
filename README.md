# 📦 Infrastructure for the User Activity Event Processing System on Azure

This document provides a detailed deployment strategy and operational overview for the **User Activity Event Processing System**, It is intended for platform, DevOps, and operations teams to understand how Azure services are provisioned and how the system is deployed and maintained using Terraform and GitOps.

---

## 1. Overview

The system is designed to handle real-time user events such as "play", "pause", "like", and "skip" from a music streaming platform. The objectives include:

- Ingesting RESTful requests with user event data.
- Normalizing and enriching events into a standard format.
- Dynamically routing events to analytics, AI, social, and storage systems.
- Storing processed event data in a secure SQL Server database.

This system is modular, scalable, and ready to integrate new event types or downstream services with minimal change.

---

## 2. Directory Structure

The repository is organized to separate concerns of Azure infrastructure deployment (infra/) and Kubernetes/Helm/Argo CD deployment (k8s/). 

Additionally, the bootstrap/ folder contains the Terraform configuration that provisions an Azure Storage Account for remote backend state.

```
bootstrap/
├── main.tf              # Creates tfstate resource group, storage account, and container
├── variables.tf         # Configurable variables like name, location
└── outputs.tf           # Outputs used in main infra

scripts/
└── bootstrap.sh         # Script to initialize remote state storage

infra/
├── main.tf              # Main Terraform configuration for Azure resources
├── variables.tf         # Variable definitions
├── outputs.tf           # Output definitions (e.g., AKS kubeconfig, connection info)
├── resources.tf         # Resource configurations for Azure (AKS, ACR, SQL, etc.)
├── modules/             # Reusable Terraform modules
│   ├── network/         
│   ├── aks/             
│   ├── acr/             
│   └── database/        
└── environments/        # Environment-specific Terraform configurations
    ├── dev/             # Dev environment for infrastructure development
    └── test/            # Test environment for integration testing

k8s/
├── main.tf              # Terraform for Helm, Argo CD, and Kubernetes-level config
├── variables.tf         # Variable definitions for k8s stage
├── outputs.tf           # K8s-related outputs, if any
└── helm_charts/         # (Optional) Helm charts or references, if managed here

```

- `bootstrap/`: Sets up the Azure Storage Account for Terraform remote state.
- `infra/`: Creates all Azure resources (AKS, ACR, VNet, SQL, etc.) and outputs the connection details that the Kubernetes configuration needs.
- `k8s/`: Manages the Kubernetes environment, including Helm releases, Argo CD installations, and application-level deployments.
- `scripts/`: Contains helper scripts for bootstrapping and other tasks.

---

## 3. Prerequisites

### Remote Backend Bootstrap Setup

Before deploying infrastructure environments, this repository includes a `bootstrap/` module to provision the backend required for remote Terraform state.

The `bootstrap/` folder provisions:
- A dedicated resource group for state management (e.g., `rg-tfstate`)
- An Azure Storage Account (globally unique)
- A blob container to store environment-specific `.tfstate` files

This backend is used by all environments (e.g., `dev`, `test`) to manage state consistently and securely.

To set up the backend:
```bash
cd bootstrap
terraform init
terraform apply
```

After applying, you can proceed to use the outputs (e.g., storage account name, container name) in the `backend.tf` of each environment.

- Terraform v1.0.0+
- Azure CLI installed and configured
- Sufficient Azure permissions to create required resources

---

## 4. Core Azure Services & Components

### a. Compute and Orchestration
- **Azure Kubernetes Service (AKS)**: Hosts the containerized Spring Boot application. Supports auto-scaling, integrates with ACR, and uses managed identities and RBAC for security.

- **Azure Container Registry (ACR)**: Securely stores Docker images and integrates with AKS for smooth deployments.

### b. Networking and Security
- **Virtual Network (VNet)** with dedicated subnets for AKS and databases.
- **Network Security Groups (NSGs)**: Control inbound and outbound traffic.
- **Private Endpoints and Firewall Rules**: Secure database access by limiting it to the VNet.

### c. Data Storage
- **Azure SQL Server**: Stores processed events with high availability, backup, and encryption features.

### d. Monitoring and Logging
- **Azure Monitor & Log Analytics**: Tracks performance metrics, aggregates logs, and provides real-time alerting.
- **Application Insights (Optional)**: Deep telemetry for the Spring Boot app.

---

## 5. Deployment Strategy, GitOps & CI/CD Process

### GitOps for Infrastructure and Applications

This section describes how GitOps is used to manage both infrastructure and application layers.

#### Argo CD Application Management Strategy

According to GitOps best practices, we do not manage Argo CD Application resources directly in Terraform. Instead, all application deployment definitions are stored in a dedicated application Git repository for version control:

➡️ **Music Activity Processing System Application Repository**: [https://github.com/chienaeae/music-activity-processing-system](https://github.com/chienaeae/music-activity-processing-system)

In this repository, Argo CD Application manifest files are stored in a dedicated folder (e.g., `apps/applications/`):

```
apps/
└── applications/
    ├── user-event-dev.yaml
    ├── user-event-test.yaml
    └── ...
```

Each file is a declarative Argo CD `Application` resource, defining the Git repository, path, and target namespace. These manifest files are automatically recognized and synced by Argo CD.

#### Architecture Overview

1. **Infrastructure Layer (Terraform managed)**:
   - Azure resources (AKS, ACR, SQL, etc.)
   - Argo CD installation (using Helm)
   - Network and security settings

2. **Application Layer (GitOps/Argo CD managed)**:
   - Application deployment manifests
   - Configuration and environment variables
   - Service definitions
   - Resource requests and limits

#### GitOps Workflow

1. Developers update the Kubernetes configuration (YAML/Helm/Kustomize) in the application Git repository
2. Argo CD continuously monitors the Git repository and automatically syncs changes to the AKS cluster
3. All configuration and deployment changes are version-controlled and audited through Git



### a. Environment Setup

- **Dev Environment**: A stable environment used for infrastructure development and internal testing. It supports iterative changes during feature implementation.

- **Test Environment**: Provisioned temporarily for integration testing. It can be recreated or destroyed easily to reduce cost.

> **Note:** This is an experimental project, and no dedicated production environment is currently planned or maintained.

### b. Usage Instructions

#### Deploy Dev Environment
```bash
cd environments/dev
terraform init
terraform plan -var="sql_admin_password=<your-secure-password>"
terraform apply -var="sql_admin_password=<your-secure-password>"
```

#### Deploy Test Environment
```bash
cd environments/test
terraform init
terraform plan -var="sql_admin_password=<your-secure-password>"
terraform apply -var="sql_admin_password=<your-secure-password>"
```


#### Destroy Dev Environment
```bash
cd environments/dev
terraform destroy -var="sql_admin_password=<your-secure-password>"
```

#### Destroy Test Environment
```bash
terraform destroy -var="sql_admin_password=<your-secure-password>"
```

### c. GitOps Integration with Argo CD

- **Argo CD** is automatically installed into the AKS cluster using a Terraform-managed Helm release.
- Each environment includes a Terraform definition for one or more `argocd_application` resources that point to the Git-based application configuration repository.
- Argo CD watches the app repository and automatically deploys/update Kubernetes manifests stored under environment-specific paths.

#### GitOps Workflow
1. Developers update Kubernetes configurations (YAML/Helm/Kustomize) in the app repo.
2. Argo CD continuously syncs the changes from Git to the AKS cluster.
3. All configuration and deployment changes are version-controlled and auditable via Git.

### d. CI/CD Pipeline

- **GitHub Actions Pipelines** automate provisioning and deployments:
  - Terraform Init → Plan → Apply
  - Build and Push container images to ACR
  - Update application configuration repository (e.g., image tag)
  - Argo CD automatically syncs the latest config to the cluster

- **Secrets Management**: GitHub Secrets and/or Azure Key Vault are used for managing sensitive data.

### e. Two-stage Terraform Deployment Strategy

In this architecture, Terraform is divided into two stages to deploy the base resources and Kubernetes applications, making the process easier to maintain and expand:

- `infra/`

Responsible for creating Azure core resources (e.g., AKS, ACR, SQL Database, VNet, etc.) and outputting AKS connection information (e.g., kubeconfig, cluster name, etc.) for subsequent use.

Since this stage focuses on cloud infrastructure, it ensures that relevant network settings, permissions, and security are in place before coupling with Kubernetes-related configurations.

- `k8s/`

Responsible for managing Helm, Argo CD, and Kubernetes application deployments.

This stage can flexibly configure and upgrade applications, Helm charts, and GitOps without frequent changes to the underlying Azure resources.

To avoid the issue of Terraform Provider prematurely parsing AKS module information in the k8s/ project, we can use explicit input/output variables to pass necessary parameters or use Terraform's depends_on to ensure that the infrastructure is ready before proceeding to the Kubernetes-level configuration.

This two-stage deployment approach helps maintain modularity and maintainability of the architecture:

- Long-term expansion: Whether to add other Azure services, expand Kubernetes modules, or update application deployments, can be done in a relatively independent stage.

- Repeatable deployment: When deploying to different regions or environments, it only needs to copy and adjust the variables and settings of the infra/ and k8s/ projects, and then quickly build the same architecture.

---

## 6. Features and Functionality

1. **Modular Design**: Reusable Terraform modules for key services.
2. **Environment Separation**: Supports dev and test environments for infrastructure development and integration testing respectively.
3. **Network Isolation**: Secure traffic flow between internal services.
4. **Managed Identity**: Uses Azure identities over hardcoded credentials.
5. **Auto Scaling**: AKS scales based on workload automatically.
6. **GitOps Deployment**: All app deployments are declaratively managed through Git.

---

## 7. Security and Compliance

- Use managed identities, RBAC, and service principals for secure interaction.
- Use private endpoints and encryption for data protection.
- Follow org-wide security baselines and policies.
- Argo CD is configured with limited privileges and isolated namespaces.

---

## 8. Maintenance & Operations

### a. Monitoring
- Use Azure Monitor and Log Analytics for health checks and alerts.

### b. Regular Updates
- Patch infrastructure modules and application containers regularly.
- Use blue/green or canary strategies to reduce downtime.

### c. Backup & Recovery
- Schedule SQL backups.
- Document and test DR procedures.

---

## 9. Customization Options

Modify `variables.tf` or provide CLI variables to adjust:
- Resource sizes/SKUs
- Network CIDRs
- AKS version
- Scaling parameters
- Argo CD application sync targets

---

## 10. Troubleshooting Tips

- Ensure Azure permissions are sufficient
- Check Terraform logs for detailed errors
- Validate CIDR ranges and resource naming
- Confirm ACR and AKS integration
- Check Argo CD UI or logs if application is not synced

---

## Conclusion

This Terraform-based infrastructure setup enables a scalable, secure, and repeatable deployment of the User Activity Event Processing System on Azure. Combined with GitOps and CI/CD automation, it ensures fast, traceable, and reliable delivery of both platform and application layers across environments.


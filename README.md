# Terraform GitHub Actions for Azure Infrastructure

This repository demonstrates how to automate Terraform deployments to Azure using GitHub Actions with OIDC authentication

---

## Overview

This project uses:

- **GitHub Actions** for CI/CD pipeline  
- **Terraform** to define Azure infrastructure as code 
- **Azure OIDC-Authentifizierung** Azure OIDC authentication for secure, passwordless authentication  

The Terraform configuration will deploy:

- A resource group  
- A virtual network  
- A subnet 

---

## Prerequisites

Before using this project, you need to:

1. Have an Azure subscription  
2. Have GitHub repository access with permissions to set secrets
3. Install the Azure CLI 
4. Run the `Pre-Reqs.ps1`script to set up required Azure resources

---

## Setup Instructions

### 1. Run the Prerequisites Script

> **IMPORTANT:**  You must run the **`Pre-Reqs.ps1`** script before proceeding. This script.

Dieses Skript:
- Creates a resource group for Terraform state storage 
- Creates an Azure storage account for the Terraform backend
- Creates a blob container for state file
- Creates a managed identity for Terraform operations 
- Assigns necessary permissions

**To run the script::**

```powershell
# Variablen im Skript überprüfen und anpassen:
# - $RESOURCE_GROUP (muss zu main.tf passen)
# - $STORAGE_ACCOUNT_NAME (muss global eindeutig sein)

# 1. In Azure einloggen
az login

# 2. Skript ausführen
.\Pre-Reqs.ps1
```

### 2. Configure GitHub Repository Secrets

Set up the following secrets in your GitHub repository:

- AZURE_AD_CLIENT_ID: The client ID of your Azure managed identity
- AZURE_SUBSCRIPTION_ID: Your Azure subscription ID
- AZURE_TENANT_ID: Your Azure tenant ID

### 3. Configure Azure Federated Credentials
1. Navigate to your Azure Portal
2. Open Azure Active Directory → App Registrations
3. Find the managed identity created by the script
4. Add federated credentials with:
    - Issuer: https://token.actions.githubusercontent.com
    - Subject: repo:your-username/tf-gha-beginners:ref:refs/heads/main
    - Name: github-actions-oidc
    - Audience: api://AzureADTokenExchange

## Workflow Usage
The GitHub Actions workflow is configured to run manually using workflow_dispatch. You can trigger it from the "Actions" tab in your GitHub repository.

The workflow:

1. Authenticates to Azure using OIDC
2. Checks out your code
3. Formats, initializes, and validates the Terraform configuration
4. Creates an execution plan
5. Applies the changes (only on the main branch)

## File Structure
- `terraform.yaml`
- `main.tf`
- `Pre-Reqs.ps1`

## Updating Resources
To modify the Azure infrastructure
1. Edit the Terraform files in the `terraform` directory
2. Commit and push changes to GitHub
3. Run the workflow from the GitHub Actions tab

## Best Practices
- Use pinned versions for GitHub Actions to ensure stability
- Store Terraform state in a secure, remote backend
- Use OIDC authentication to avoid storing credentials
- Apply least privilege security principles
- Test changes in a development environment before applying to production

## Troubleshooting
If you encounter authentication issues:

- Verify that your GitHub repository secrets are correctly set
- Ensure the federated credentials in Azure are properly configured
- Check that the managed identity has appropriate permissions
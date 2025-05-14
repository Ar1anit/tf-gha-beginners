# Script: Create Azure resources with a Managed Identity and assign Owner role

# Prerequisites:
# - Install the Azure CLI (https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
# - Authenticate with the Azure CLI (https://docs.microsoft.com/en-us/cli/azure/authenticate-azure-cli)
# - Make sure you have the necessary permissions to create resources in the subscription
# - Perform "az login" before running this script

# Define variables (adjust if needed)
$RESOURCE_GROUP = "your-tf-rg-name" # Replace with your desired resource group name
$LOCATION = "westeurope"
# Storage account names must be globally unique; a timestamp is appended here.
$STORAGE_ACCOUNT_NAME = "tfstorage$(Get-Date -Format 'yyyyMMddHHmm')"
$CONTAINER_NAME = "tfstate"
$IDENTITY_NAME = "tf-ManagedIdentity"

# Create a resource group
Write-Host "Creating resource group '$RESOURCE_GROUP' in '$LOCATION'..."
az group create --name $RESOURCE_GROUP --location $LOCATION

# Create a storage account
Write-Host "Creating storage account '$STORAGE_ACCOUNT_NAME' in resource group '$RESOURCE_GROUP'..."
az storage account create --name $STORAGE_ACCOUNT_NAME --resource-group $RESOURCE_GROUP --location $LOCATION --sku Standard_LRS

# Create a blob container
Write-Host "Creating blob container '$CONTAINER_NAME' in storage account '$STORAGE_ACCOUNT_NAME'..."
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME

# Create a managed identity
Write-Host "Creating managed identity '$IDENTITY_NAME' in resource group '$RESOURCE_GROUP'..."
az identity create --name $IDENTITY_NAME --resource-group $RESOURCE_GROUP  --location $LOCATION

# Retrieve the managed identity principalId
$PRINCIPAL_ID = az identity show --name $IDENTITY_NAME --resource-group $RESOURCE_GROUP --query principalId -o tsv

# Retrieve the subscription ID
$SUBSCRIPTION_ID = az account show --query id -o tsv

# Assign the Owner role to the managed identity at the resource group scope
Write-Host "Assigning the Owner role to the managed identity '$IDENTITY_NAME' (principalId: $PRINCIPAL_ID)..."
az role assignment create --assignee $PRINCIPAL_ID --role Owner --scope /subscriptions/$SUBSCRIPTION_ID

Write-Host "All resources have been successfully created."
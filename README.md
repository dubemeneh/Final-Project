# CST8918 FINAL PROJECT - AZURE BICEP SCENRIO
## LECTURER

## Overview

This project demonstrates the deployment of a web application to Azure using Azure Bicep. The deployment includes an Azure SQL Database, a Storage Account for static assets, and an App Service Plan to host the web application. Deploy an App Service app for the template that will help launch the web application, but to create an App Service app, an App Service plan will be created. All resources are defined with appropriate configurations to ensure secure communication between the web app and the database.

## Components

- **SQL Logical Server**: Hosts the SQL Database.
- **SQL Database**: The database for the web application.
- **Storage Account**: Stores static assets.
- **App Service Plan**: The plan under which the web application runs.
- **Web App**: The web application hosted on Azure.

## Parameters

The following parameters are defined in the Bicep script:

- `serverName`: The name of the SQL logical server.
- `sqlDBName`: The name of the Single SQL Database.
- `location`: The location for all resources inherited from the location of the resource group.
- `administratorLogin`: The administrator username for the SQL logical server.
- `administratorLoginPassword`: The administrator password for the SQL logical server.
- `storageAccountName`: The name of the storage account.
- `appServicePlanName`: The name of the App Service Plan.
- `storageAccountSkuName`: The SKU of the storage account.
- `appServicePlanSkuName`: The SKU of the App Service Plan.

## Resources

The following resources are defined in the Bicep script:

- **SQL Logical Server**: 
    ```bicep
    resource sqlServer 'Microsoft.Sql/servers@2022-05-01-preview' = {
      name: serverName
      location: location
      properties: {
        administratorLogin: administratorLogin
        administratorLoginPassword: administratorLoginPassword
      }
    }
    ```

- **SQL Database**: 
    ```bicep
    resource sqlDB 'Microsoft.Sql/servers/databases@2022-05-01-preview' = {
      parent: sqlServer
      name: sqlDBName
      location: location
      sku: {
        name: 'Standard'
        tier: 'Standard'
      }
    }
    ```

- **Storage Account**: 
    ```bicep
    resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
      name: storageAccountName
      location: location
      sku: {
        name: storageAccountSkuName
      }
      kind: 'StorageV2'
      properties: {
        accessTier: 'Hot'
      }
    }
    ```

- **App Service Plan**: 
    ```bicep
    resource appServicePlan 'Microsoft.Web/serverfarms@2023-12-01' = {
      name: appServicePlanName
      location: location
      sku: {
        name: appServicePlanSkuName
      }
    }
    ```

## Outputs

The script outputs the following value:

- `storageAccountHostname`: The primary endpoint for the Blob service of the storage account.
    ```bicep
    output storageAccountHostname string = storageAccount.properties.primaryEndpoints.blob
    ```

## How to Deploy

1. Install Azure CLI with valid login account.
2. Navigate to the Final Project folder which contains the Bicep file.
3. Run the following command to deploy the Bicep file:

    ```sh
    az deployment group create --resource-group cstFinal --template-file main.bicep
    ```


## Security Considerations

- Ensure sensitive information such as `administratorLoginPassword` is kept secure.
- Manage connection strings securely.
- Enforce HTTPS only for the web application to enhance security.

## Student Details

Chidubem Eneh 0411087448

## References

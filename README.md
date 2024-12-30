# CST8918 FINAL PROJECT - AZURE BICEP SCENARIO

## Lecturer

Dindyal, Sourav

## Student Details

Chidubem Eneh

## Overview

This project demonstrates the deployment of a web application to Azure using Azure Bicep. The deployment includes an Azure SQL Database, a Storage Account for static assets, and an App Service Plan to host the web application. Deploy an App Service app for the template that will help launch the web application, but to create an App Service app, an App Service plan will be created. All resources are defined with appropriate configurations to ensure secure communication between the web app and the database. For this reason, https was enforced for communicating with the web app. 

## Challenge

My major challenge was in defining the app settings to accomplish  the requirements of the project.

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
- `appServiceAppName`: The name of the web app.
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

- **Web App**:
    ```bicep
    resource appServiceApp 'Microsoft.Web/sites@2023-12-01' = {
      name: appServiceAppName
      location: location
      properties: {
        serverFarmId: appServicePlan.id
        httpsOnly: true
        siteConfig: {
          appSettings: [
            {
              name: 'WEBSITE_RUN_FROM_PACKAGE'
              value: '1'
            }
            {
              name: 'AzureWebJobsStorage'
              value: storageAccount.properties.primaryEndpoints.blob
            }
            {
              name: 'SQLSERVER_CONNECTION_STRING'
              value: 'Server=tcp:${sqlServer.name}.database.windows.net;Database=${sqlDB.name};User ID=${administratorLogin};Password=${administratorLoginPassword};'
            }
          ]
        }
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

1. Install Azure CLI with a valid login account.
2. Navigate to the Final Project folder which contains the Bicep file.
3. Run the following command to deploy the Bicep file:

    ```sh
    az deployment group create --resource-group cstFinal --template-file main.bicep
    ```

## Security Considerations

- Ensure sensitive information such as `administratorLoginPassword` is kept secure.
- Manage connection strings securely.
- Enforce HTTPS only for the web application to enhance security.

## References

1. Mumian. (n.d.). Define Azure Resources in a bicep template - training: Microsoft Learn. Define Azure resources in a Bicep template - Training | Microsoft Learn. https://learn.microsoft.com/en-us/training/modules/build-first-bicep-template/3-define-resources 

2. asdpsdasdpsd36811 gold badge33 silver badges1111 bronze badges, & ThomasThomas                      28.9k66 gold badges9898 silver badges139139 bronze badges. (1967, September 1). Is there a workaround to keep app settings which not defined in bicep template?. Stack Overflow. https://stackoverflow.com/questions/72940236/is-there-a-workaround-to-keep-app-settings-which-not-defined-in-bicep-template#:~:text=Don%27t%20include%20appSettings%20inside%20the%20siteConfig%20while%20deploying.,webAppName%20parent%3A%20webApp%20name%3A%20%27appsettings%27%20properties%3A%20union%28currentAppSettings%2C%20appSettings%29 

3. Dallas, J. (2024b). CST8918 DevOps - Infrastructure as Code. Cloud Development & Operations. Ontario.

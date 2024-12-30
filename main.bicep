//Create a preferred name of the SQL logical server
param serverName string = 'sqlserver${uniqueString(resourceGroup().id)}'

//Enter the name of the SQL Database when prompted
param sqlDBName string

// Use resource group location for resource location
param location string = resourceGroup().location

// Provide administrator username of the SQL logical server
param administratorLogin string

// Provide administrator password of the SQL logical server
@secure()
param administratorLoginPassword string

// Unique Name of the storage account
param storageAccountName string = 'storage${uniqueString(resourceGroup().id)}'


// Unique Name of the storage account
param appServiceAppName string = 'appName${uniqueString(resourceGroup().id)}'

// Unique name of the App Service plan.
param appServicePlanName string = 'servPlan${uniqueString(resourceGroup().id)}'


// Parameter for the SKU of the storage account.
param storageAccountSkuName string = 'Standard_LRS'

// Service tier for the App Service plan.
param appServicePlanSkuName string = 'F1'


resource sqlServer 'Microsoft.Sql/servers@2022-05-01-preview' = {
  name: serverName
  location: location
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
  }
}

resource sqlDB 'Microsoft.Sql/servers/databases@2022-05-01-preview' = {
  parent: sqlServer
  name: sqlDBName
  location: location
  sku: {
    name: 'Standard'
    tier: 'Standard'
  }
}

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

resource appServicePlan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSkuName
  }
}

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

output storageAccountHostname string = storageAccount.properties.primaryEndpoints.blob

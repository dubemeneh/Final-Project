@description('The name of the SQL logical server.')
param serverName string = 'sqlserver${uniqueString(resourceGroup().id)}'

@description('The name of the SQL Database.')
param sqlDBName string

@description('Location for all resources.')
param location string = resourceGroup().location

@description('The administrator username of the SQL logical server.')
param administratorLogin string

@description('The administrator password of the SQL logical server.')
@secure()
param administratorLoginPassword string

@description('The name of the storage account.')
param storageAccountName string = 'storage${uniqueString(resourceGroup().id)}'

@description('The name of the App Service plan.')
param appServicePlanName string = 'servPlan${uniqueString(resourceGroup().id)}'


@description('The SKU of the storage account.')
param storageAccountSkuName string = 'Standard_LRS'

@description('The SKU of the App Service plan.')
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

output storageAccountHostname string = storageAccount.properties.primaryEndpoints.blob

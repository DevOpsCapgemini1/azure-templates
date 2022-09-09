@description('The region in which the SQL Server and Database will be created.')
param location string

@description('Name of app service plan')
param appServicePlanName string

@description('Name of web app')
param webAppName string

@description('The name and tier of SKU')
param pricing_tier object
@description('Nodes in web farm')
param num_of_workers int

@description('Docker hub image to be used')
param dockerImage string

resource appServicePlan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: appServicePlanName
  location: location
  kind: 'linux'
  properties: {
    reserved: true
    targetWorkerCount: num_of_workers
  }
  sku: {
    name: pricing_tier.name
    tier: pricing_tier.tier
  }
}
resource webApp 'Microsoft.Web/sites@2021-01-01' = {
  name: webAppName
  location: location
  properties: {
    siteConfig: {
      appSettings: []
      linuxFxVersion: dockerImage
    }
    serverFarmId: appServicePlan.id
  }
}

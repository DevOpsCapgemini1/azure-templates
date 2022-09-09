@description('Azure region of the deployment')
param location string

@description('Name of the storage account')
param storageName string

@allowed([
  'Standard_LRS'
  'Standard_ZRS'
  'Standard_GRS'
  'Standard_GZRS'
  'Standard_RAGRS'
  'Standard_RAGZRS'
  'Premium_LRS'
  'Premium_ZRS'
])

@description('Storage SKU')
param storageSkuName string
@description('Pricing Tier(accessTier)')
param accessTier string

var storageNameCleaned = replace(storageName, '-', '')

resource storage 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: storageNameCleaned
  location: location
  sku: {
    name: storageSkuName
  }
  kind: 'StorageV2'
  properties: {
    accessTier: accessTier
  }
}

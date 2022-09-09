param name string
param location string
param sku string
param softDeleteRetentionInDays int

resource symbolicname 'Microsoft.AppConfiguration/configurationStores@2022-05-01' = {
  name: name
  location: location

  sku: {
    name: sku
  }
  properties: {

    softDeleteRetentionInDays: softDeleteRetentionInDays
  }
}

param name string
param location string
param sku string

param softDeleteRetentionInDays int

resource name_resource 'Microsoft.KeyVault/vaults@2021-10-01' = {
  name: name
  location: location
  properties: {
    accessPolicies: []
    tenantId: subscription().tenantId
    sku: {
      name: sku
      family: 'A'
    }

    softDeleteRetentionInDays: softDeleteRetentionInDays
  }

}

param KeyVaultName string

param webAppName string

resource webApp 'Microsoft.Web/sites@2021-01-01' existing = {
  name: webAppName

}

resource grantAccess 'Microsoft.KeyVault/vaults/accessPolicies@2019-09-01' = {
  name: '${KeyVaultName}/add'
  properties: {
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        objectId: webApp.identity.principalId
        permissions: {
          secrets: [
            'get'
            'list'
          ]
        }
      }
    ]
  }
}

param webAppName string
param location string
resource webApp 'Microsoft.Web/sites@2021-01-01' existing = {
  name: webAppName
}

module app_managed_identity 'update-app.bicep' = {
  name: 'app_managed_identity-${webAppName}'
  params: {
    location: location
    identity: union(webApp.identity, {
        type: 'SystemAssigned'
      })
    webAppName: webAppName
  }
}

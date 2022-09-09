@description('Name of webapp')
param webAppName string
param identity object
@description('location of webapp')
param location string
resource webApp 'Microsoft.Web/sites@2021-01-01' = {
  name: webAppName
  identity: identity
  location: location
}

param vnetName string
param subnetName string
param webAppName string
param location string

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2022-01-01' existing = {
  name: '${vnetName}/${subnetName}'
}
resource webApp 'Microsoft.Web/sites@2021-01-01' existing = {
  name: webAppName
}
resource Resource_privateEndpoints 'Microsoft.Network/privateEndpoints@2021-05-01' = {
  name: webAppName
  location: location
  properties: {
    subnet: {
      id: subnet.id
    }
    privateLinkServiceConnections: [
      {
        name: webAppName
        properties: {
          privateLinkServiceId: webApp.id
          groupIds: [
            'sites'
          ]
        }
      }
    ]
  }
}

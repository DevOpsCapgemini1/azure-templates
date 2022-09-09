@description('Name of vnet')
param vnetName string
@description('Name of subnet')
param subnetName string

@description('Name of subnet')
param webAppName string

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2022-01-01' existing = {
  name: '${vnetName}/${subnetName}'
}
resource webApp 'Microsoft.Web/sites@2021-01-01' existing = {
  name: webAppName
}

module vnet_integration 'update-subnet.bicep' = {
  name: 'update-vnet-subnet-${vnetName}-${subnetName}'
  params: {
    vnetName: vnetName
    subnetName: subnetName
    properties: union(subnet.properties, {
        delegations: [
          {
            name: 'delegation'
            properties: {
              serviceName: 'Microsoft.Web/serverFarms'
            }
          }
        ]
      })
  }
}
module vnet_integration_web_app 'appservice.bicep' = {
  name: 'update-app-subnet-${vnetName}-${subnetName}-${webAppName}'
  params: {
    location: 'uksouth'
    properties: union(webApp.properties, {
        virtualNetworkSubnetId: subnet.id
      })
    webAppName: webAppName
  }
}

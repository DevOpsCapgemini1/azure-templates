@description('Name of nsg')
param nsgName string
@description('Name of vnet')
param vnetName string
@description('Name of subnet')
param subnetName string

resource nsg 'Microsoft.Network/networkSecurityGroups@2022-01-01' existing = {
  name: nsgName
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2022-01-01' existing = {
  name: '${vnetName}/${subnetName}'
}

module attachNsg 'subnet-nsg-assign.bicep' = {
  name: 'update-vnet-subnet-${vnetName}-${subnetName}'
  params: {
    vnetName: vnetName
    subnetName: subnetName
    properties: union(subnet.properties, {
        networkSecurityGroup: {
          id: nsg.id
        }
      })
  }
}

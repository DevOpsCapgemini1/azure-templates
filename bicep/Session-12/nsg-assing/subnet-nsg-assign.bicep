@description('Name of vnet')
param vnetName string
@description('Name of subnet')
param subnetName string
param properties object
resource subnet 'Microsoft.Network/virtualNetworks/subnets@2022-01-01' = {
  name: '${vnetName}/${subnetName}'
  properties: properties
}

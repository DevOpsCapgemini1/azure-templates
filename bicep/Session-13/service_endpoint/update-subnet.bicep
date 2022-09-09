@description('Name of vnet')
param vnetName string
@description('Name of subnet')
param subnetName string
// @description('Name of webapp')
// param webAppName string
param properties object
// @description('location of webapp')
// param location string
resource subnet 'Microsoft.Network/virtualNetworks/subnets@2022-01-01' = {
  name: '${vnetName}/${subnetName}'
  properties: properties
}
// resource webApp 'Microsoft.Web/sites@2021-01-01' = {
//   name: webAppName
//   properties: properties
// }

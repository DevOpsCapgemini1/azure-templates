@description('Region of nsg')
param location string

@description('Name of nsg')
param name string

@description('Array of subnets')
param arrayOfRules array

resource symbolicname 'Microsoft.Network/networkSecurityGroups@2022-01-01' = {
  name: name
  location: location
  properties: {
    securityRules: [for rule in arrayOfRules: {
      name: rule.name
      properties: {
        protocol: rule.protocol
        sourcePortRange: rule.sourcePortRange
        destinationPortRange: rule.destinationPortRange
        sourceAddressPrefix: rule.sourceAddressPrefix
        destinationAddressPrefix: rule.destinationAddressPrefix
        access: rule.access
        priority: rule.priority
        direction: rule.direction
      }

    }]
  }

}

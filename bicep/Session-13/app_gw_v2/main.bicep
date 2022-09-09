param location string
param applicationGatewayName string
param tier string
param skuSize string
param capacity int = 2
param subnetName string
param zones array
param publicIpAddressName string
param sku string
param allocationMethod string
param publicIpZones array
param autoScaleMaxCapacity int

var vnetId = '/subscriptions/7d357068-33cb-4607-bb4d-02eaf5d20f25/resourceGroups/uksouthgrp/providers/Microsoft.Network/virtualNetworks/myVnetName'
var publicIPRef = publicIpAddressName_resource.id
var subnetRef = '${vnetId}/subnets/${subnetName}'
resource applicationGatewayName_resource 'Microsoft.Network/applicationGateways@2021-08-01' = {
  name: applicationGatewayName
  location: location
  zones: zones
  tags: {
  }
  properties: {
    sku: {
      name: skuSize
      tier: tier
    }
    gatewayIPConfigurations: [
      {
        name: 'appGatewayIpConfig'
        properties: {
          subnet: {
            id: subnetRef
          }
        }
      }
    ]
    frontendIPConfigurations: [
      {
        name: 'appGwPublicFrontendIp'
        properties: {
          publicIPAddress: {
            id: publicIPRef
          }
        }
      }
    ]
    frontendPorts: [
      {
        name: 'port_80'
        properties: {
          port: 80
        }
      }
    ]
    backendAddressPools: [
      {
        name: 'MyBackendPool'
        properties: {
          backendAddresses: [
            {
              fqdn: 'myuniquewebappname.azurewebsites.net'
            }
          ]
        }
      }
    ]
    backendHttpSettingsCollection: [
      {
        name: 'MyBackendSettings'
        properties: {
          port: 80
          protocol: 'Http'
          cookieBasedAffinity: 'Disabled'
          requestTimeout: 20
          pickHostNameFromBackendAddress: true
          probe: {
            id: resourceId('Microsoft.Network/applicationGateways/probes', applicationGatewayName, 'MyBackendSettings3ad01dc3-7c27-4fc0-aa7b-edd7a3535050')

          }
        }
      }
    ]
    backendSettingsCollection: []
    httpListeners: [
      {
        name: 'MyListener'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations', applicationGatewayName, 'appGwPublicFrontendIp')

          }
          frontendPort: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendPorts', applicationGatewayName, 'port_80')
          }
          protocol: 'Http'
          sslCertificate: null
        }
      }
    ]
    listeners: []
    requestRoutingRules: [
      {
        name: 'MyRoutingRule'
        properties: {
          ruleType: 'Basic'
          httpListener: {
            id: resourceId('Microsoft.Network/applicationGateways/httpListeners', applicationGatewayName, 'MyListener')
          }
          priority: 100
          backendAddressPool: {
            id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', applicationGatewayName, 'MyBackendPool')

          }
          backendHttpSettings: {
            id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', applicationGatewayName, 'MyBackendSettings')
          }
        }
      }
    ]
    routingRules: []
    enableHttp2: false
    sslCertificates: []
    probes: [
      {
        name: 'MyBackendSettings3ad01dc3-7c27-4fc0-aa7b-edd7a3535050'
        properties: {
          backendHttpSettings: [
            {
              id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', applicationGatewayName, 'MyBackendSettings')
            }
          ]
          interval: 30
          minServers: 0
          path: '/'
          protocol: 'Http'
          timeout: 30
          unhealthyThreshold: 3
          pickHostNameFromBackendHttpSettings: true
        }
      }
    ]
    autoscaleConfiguration: {
      minCapacity: capacity
      maxCapacity: autoScaleMaxCapacity
    }
  }
}

resource publicIpAddressName_resource 'Microsoft.Network/publicIPAddresses@2020-08-01' = {
  name: publicIpAddressName
  location: location
  sku: {
    name: sku
  }
  zones: publicIpZones
  properties: {
    publicIPAllocationMethod: allocationMethod
  }
}

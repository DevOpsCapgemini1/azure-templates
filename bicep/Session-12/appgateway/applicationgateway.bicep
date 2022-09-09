@description('Application gateway name')
param applicationGatewayName string

@description('Application gateway location')
param location string

@description('Application gateway tier')
@allowed([
  'Standard'
  'WAF'
  'Standard_v2'
  'WAF_v2'
])
param tier string

@description('Application gateway sku')
@allowed([
  'Standard_Small'
  'Standard_Medium'
  'Standard_Large'
  'WAF_Medium'
  'WAF_Large'
  'Standard_v2'
  'WAF_v2'
])
param sku string

@description('Enable HTTP/2 support')
param http2Enabled bool = true

@minValue(1)
@maxValue(32)
param capacity int = 2

@minValue(1)
@maxValue(32)
param autoScaleMaxCapacity int = 10

@description('Public ip address name')
param publicIpAddressName string

@description('Virutal network subscription id')
param vNetSubscriptionId string = subscription().subscriptionId

@description('Virutal network resource group')
param vNetResourceGroup string

@description('Virutal network name')
param vNetName string

@description('Application gateway subnet name')
param subnetName string

@description('Array containing http listeners')

param httpListeners array

@description('Array containing backend address pools')

param backendAddressPools array

@description('Array containing backend http settings')

param backendHttpSettings array

@description('Array containing request routing rules')

param rules array

@description('Array containing front end ports')

param frontEndPorts array

@description('Enable web application firewall')
param enableWebApplicationFirewall bool = false

@description('Name of the firewall policy')
param firewallPolicyName string

@description('Array containing the firewall policy settings')

param firewallPolicySettings object = {
  requestBodyCheck: true
  maxRequestBodySizeInKb: 128
  fileUploadLimitInMb: 100
  state: 'Enabled'
  mode: 'Detection'
}

@description('Array containing the firewall policy custom rules.')

param firewallPolicyCustomRules array = []

@description('Array containing the firewall policy managed rule sets.')
@metadata({
  ruleSetType: 'Rule set type'
  ruleSetVersion: 'Rule set version'
})
param firewallPolicyManagedRuleSets array

param firewallPolicyManagedRuleExclusions array = []

var gatewayIpConfigurationName = 'appGatewayIpConfig'
var frontendIpConfigurationName = 'appGwPublicFrontendIp'

resource publicIpAddress 'Microsoft.Network/publicIPAddresses@2021-03-01' = {
  name: publicIpAddressName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource applicationGateway 'Microsoft.Network/applicationGateways@2021-03-01' = {
  name: applicationGatewayName
  location: location

  properties: {
    sku: {
      name: sku
      tier: tier
    }
    autoscaleConfiguration: {
      minCapacity: capacity
      maxCapacity: autoScaleMaxCapacity
    }
    enableHttp2: http2Enabled
    webApplicationFirewallConfiguration: enableWebApplicationFirewall ? {
      enabled: firewallPolicySettings.state == 'Enabled' ? true : false
      firewallMode: firewallPolicySettings.mode
      ruleSetType: 'OWASP'
      ruleSetVersion: '3.2'
    } : null
    gatewayIPConfigurations: [
      {
        name: gatewayIpConfigurationName
        properties: {
          subnet: {
            id: resourceId(vNetSubscriptionId, vNetResourceGroup, 'Microsoft.Network/virtualNetworks/subnets', vNetName, subnetName)
          }
        }
      }
    ]
    frontendIPConfigurations: [
      {
        name: frontendIpConfigurationName
        properties: {
          publicIPAddress: {
            id: publicIpAddress.id
          }
        }
      }
    ]
    frontendPorts: [for frontEndPort in frontEndPorts: {
      name: frontEndPort.name
      properties: {
        port: frontEndPort.port
      }
    }]

    backendAddressPools: [for backendAddressPool in backendAddressPools: {
      name: backendAddressPool.name
      properties: {
        backendAddresses: backendAddressPool.backendAddresses
      }
    }]
    firewallPolicy: enableWebApplicationFirewall ? {
      id: firewallPolicy.id
    } : null

    backendHttpSettingsCollection: [for backendHttpSetting in backendHttpSettings: {
      name: backendHttpSetting.name
      properties: {
        port: backendHttpSetting.port
        protocol: backendHttpSetting.protocol
        cookieBasedAffinity: backendHttpSetting.cookieBasedAffinity
        affinityCookieName: contains(backendHttpSetting, 'affinityCookieName') ? backendHttpSetting.affinityCookieName : null
        requestTimeout: backendHttpSetting.requestTimeout
        connectionDraining: backendHttpSetting.connectionDraining
      }
    }]
    httpListeners: [for httpListener in httpListeners: {
      name: httpListener.name
      properties: {
        frontendIPConfiguration: {
          id: resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations', applicationGatewayName, frontendIpConfigurationName)
        }
        frontendPort: {
          id: resourceId('Microsoft.Network/applicationGateways/frontendPorts', applicationGatewayName, httpListener.frontEndPort)
        }
        protocol: httpListener.protocol
      }
    }]
    requestRoutingRules: [for rule in rules: {
      name: rule.name
      properties: {
        ruleType: rule.ruleType
        httpListener: contains(rule, 'listener') ? json('{"id": "${resourceId('Microsoft.Network/applicationGateways/httpListeners', applicationGatewayName, rule.listener)}"}') : null
        backendAddressPool: contains(rule, 'backendPool') ? json('{"id": "${resourceId('Microsoft.Network/applicationGateways/backendAddressPools', applicationGatewayName, rule.backendPool)}"}') : null
        backendHttpSettings: contains(rule, 'backendHttpSettings') ? json('{"id": "${resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', applicationGatewayName, rule.backendHttpSettings)}"}') : null
      }
    }]

  }
}

resource firewallPolicy 'Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies@2021-03-01' = if (enableWebApplicationFirewall) {
  name: firewallPolicyName == '' ? 'placeholdervalue' : firewallPolicyName
  location: location
  properties: {
    customRules: firewallPolicyCustomRules
    policySettings: firewallPolicySettings
    managedRules: {
      managedRuleSets: firewallPolicyManagedRuleSets
      exclusions: firewallPolicyManagedRuleExclusions
    }
  }
}

output name string = applicationGateway.name
output id string = applicationGateway.id

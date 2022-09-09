param deploymentName string = 'appgw${utcNow()}'

module appGateway 'applicationgateway.bicep' = {
  name: deploymentName
  params: {
    location: 'westeurope'
    applicationGatewayName: 'MyApplicationGateway'
    sku: 'WAF_v2'
    tier: 'WAF_v2'
    enableWebApplicationFirewall: true
    firewallPolicyName: 'MyFirewallPolicyName'
    publicIpAddressName: 'MyPublicIpAddress'
    vNetResourceGroup: 'MyResourceGroup921'
    vNetName: 'myVVNET'
    subnetName: 'mySubnet-ps'
    firewallPolicyManagedRuleSets: [
      {
        ruleSetType: 'OWASP'
        ruleSetVersion: '3.2'
      }
    ]
    frontEndPorts: [
      {
        name: 'port_80'
        port: 80
      }
    ]
    httpListeners: [
      {
        name: 'MyHttpListener'
        protocol: 'Http'
        frontEndPort: 'port_80'
      }
    ]
    backendAddressPools: [
      {
        name: 'MyBackendPool'
        backendAddresses: [
          {
            ipAddress: '10.1.2.3'
          }
        ]
      }
    ]
    backendHttpSettings: [
      {
        name: 'MyBackendHttpSetting'
        port: 80
        protocol: 'Http'
        cookieBasedAffinity: 'Enabled'
        affinityCookieName: 'MyCookieAffinityName'
        requestTimeout: 300
        connectionDraining: {
          drainTimeoutInSec: 60
          enabled: true
        }
      }
    ]
    rules: [
      {
        name: 'MyRuleName'
        ruleType: 'Basic'
        listener: 'MyHttpListener'
        backendPool: 'MyBackendPool'
        backendHttpSettings: 'MyBackendHttpSetting'
      }
    ]
  }
}

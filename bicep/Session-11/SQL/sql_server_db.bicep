@description('The region in which the SQL Server and Database will be created.')
param location string

@description('Name of primary SQL server')
param serverName string

@description('The name of the SQL Database.')
param sqlDBName string

@description('The name and tier of SKU')
param pricing_tier object

param DbBackupPolicy string

@description('Firewall rules.')
param ArrayOfRules array

@description('The administrator username of the SQL logical server.')
param administratorLogin string

@description('The administrator password of the SQL logical server.')
@secure()
param administratorLoginPassword string

resource serverName_resource 'Microsoft.Sql/servers@2022-02-01-preview' = {
  name: serverName
  location: location
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
  }
}

resource serverName_sqlDBName 'Microsoft.Sql/servers/databases@2022-02-01-preview' = {
  parent: serverName_resource
  name: sqlDBName
  location: location
  sku: {
    name: pricing_tier.name
    tier: pricing_tier.tier
  }
  properties: {
    requestedBackupStorageRedundancy: DbBackupPolicy
  }
}

resource sqlServerFirewallRules 'Microsoft.Sql/servers/firewallRules@2022-02-01-preview' = [for rule in ArrayOfRules: {
  parent: serverName_resource
  name: rule.name
  properties: {
    startIpAddress: rule.startIpAddress
    endIpAddress: rule.endIpAddress
  }

}]

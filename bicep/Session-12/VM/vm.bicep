@description('Name of the VM')
param vmName string

@description('VM Image')
param vmImage object

@description('VM pricing tier')
param pricing_tier string

@description('VM disk pricing tier')
param disk_pricing_tier string
@description('VNet name')
param vnetName string
@description('subnet Name')
param subnetName string
@description('Location of the VM')
param location string
param adminUsername string
@secure()
param adminPassword string

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' existing = {
  name: vnetName
}
var subnetRef = '${virtualNetwork.id}/subnets/${subnetName}'

resource nic 'Microsoft.Network/networkInterfaces@2020-06-01' = {
  name: '${vmName}-network_interface'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnetRef
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}
resource vm 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: pricing_tier
    }
    storageProfile: {
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: disk_pricing_tier
        }
      }
      imageReference: {
        publisher: vmImage.publisher
        offer: vmImage.offer
        sku: vmImage.sku
        version: vmImage.version
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword

    }

  }

}

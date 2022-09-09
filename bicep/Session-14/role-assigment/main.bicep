param appConfigurationName string
param webAppName string

resource webApp 'Microsoft.Web/sites@2022-03-01' existing = {
  name: webAppName
}

module roleAssignment 'app-configuration-role-assignment.bicep' = {
  name: 'app-configuration-role-assignment-to-webapp'
  scope: resourceGroup()
  params: {
    appConfigurationName: appConfigurationName
    principalId: webApp.identity.principalId
    roleId: '516239f1-63e1-4d78-a4de-a74fb236a071'
  }
}

@description('Name of web app')
param webAppName string

@description('SAS URL to the container.')
param storageAccountUrl string
@description('Schedule for the backup')
param backupSchedule object

resource webApp 'Microsoft.Web/sites@2022-03-01' existing = {
  name: webAppName
}

resource symbolicname 'Microsoft.Web/sites/config@2022-03-01' = {
  name: 'backup'
  parent: webApp
  kind: 'backup'
  properties: {
    backupName: 'mybackup'
    backupSchedule: {
      frequencyInterval: backupSchedule.frequencyInterval
      frequencyUnit: backupSchedule.frequencyUnit
      keepAtLeastOneBackup: backupSchedule.keepAtLeastOneBackup
      retentionPeriodInDays: backupSchedule.retentionPeriodInDays
      startTime: backupSchedule.startTime
    }
    databases: [
      {
        connectionString: 'Server=tcp:myuniquesqlserver.database.windows.net,1433;Initial Catalog=myUniqueSqlDatabase;Persist Security Info=False;User ID=mbinds;Password=VeryHardPassword123!;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;'
        connectionStringName: 'sqqx'
        databaseType: 'SqlAzure'
        name: 'myuniquesqlserver'
      }
    ]
    enabled: true
    storageAccountUrl: storageAccountUrl
  }
}

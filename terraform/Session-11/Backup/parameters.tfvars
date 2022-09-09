appServicePlanName  = "someserviceplan"
resourceGroupName   = "MyResourceGroup921"
appName             = "myuniquelinuxwebapplication"
location            = "West Europe"
storage_account_url = "https://storageaccountnameqwetih.blob.core.windows.net/mycontainer?sp=racwdli&st=2022-08-31T12:12:45Z&se=2022-08-31T20:12:45Z&sv=2021-06-08&sr=c&sig=WbsDWM9WWNIoopFkBTDAOBHLhnZf4aVIZOdODRRaAZA%3D"
schedule = {
  frequency_interval       = 30
  frequency_unit           = "Day"
  keep_at_least_one_backup = true
  retention_period_in_days = 10
  start_time               = "2022-08-31T07:14:20.52Z"
}

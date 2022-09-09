request_routing_rules = [{
  "name"                      = "requestroutingrule",
  "http_listener_name"        = "myhttplistener"
  "backend_address_pool_name" = "mybackendaddresppol"
}]

frontend_endpoints = [{
  "name" = "port_80",
  "port" = "80"
}]

http_listeners = [{
  "name"               = "myhttplistener",
  "frontend_port_name" = "port_80"
}]

backend_address_pools = [{
  "name"         = "mybackendaddresppol",
  "ip_addresses" = ["10.1.2.3"]
}]
http_setting_name              = "myuniquehttpsettings"
location                       = "eastus"
frontend_ip_configuration_name = "myfrontendipconfiguration"
gatewayName                    = "myuniqgatewayname"
resource_group_name            = "tfeastus"

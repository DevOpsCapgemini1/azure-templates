location = "eastus"
nsgName  = "myNsgName"
rules = [{
  "name"                       = "rule-01",
  "priority"                   = "200",
  "direction"                  = "Inbound",
  "access"                     = "Allow",
  "protocol"                   = "Tcp",
  "destination_port_ranges"    = ["22", "23"],
  "source_address_prefix"      = "*",
  "destination_address_prefix" = "*"
  },
  {
    "name"                       = "rule-01-outbound",
    "priority"                   = "300",
    "direction"                  = "Outbound",
    "access"                     = "Allow",
    "protocol"                   = "Tcp",
    "destination_port_ranges"    = ["53", "88", "389", "636"],
    "source_address_prefix"      = "*",
    "destination_address_prefix" = "172.31.201.11/32"
  }
]

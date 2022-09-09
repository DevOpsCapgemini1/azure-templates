# templates

When it comes to updating resource f.e adding system-managed identity for app service, assining and existing nsg to existing subnet within vnet - all of my ARM/Bicep/Terraform templates use existing resources instead of creating a new one which I provide this new paramaters. For this, In bicep I used modules and for terraform I used terraform import.
.

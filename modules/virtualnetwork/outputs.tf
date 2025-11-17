output "virtual_network_resource_ids" {
  description = "The created virtual network resource IDs, expressed as a map."
  value = {
    for k, v in module.virtual_networks : k => v.resource_id
  }
}

output "subnet_resource_ids" {
  description = "The created subnet resource IDs, expressed as a map of maps."
  value = {
    for vnet_k, vnet_v in module.virtual_networks : vnet_k => {
      for subnet_k, subnet_v in vnet_v.subnets : subnet_k => subnet_v
    }
  }
}
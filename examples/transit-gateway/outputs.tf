output "customer_gateway_id" {
  description = "ID of the Customer Gateway"
  value       = module.vpn.customer_gateway_id
}

output "vpn_connection_id" {
  description = "ID of the VPN Connection"
  value       = module.vpn.vpn_connection_id
}

output "vpn_connection_transit_gateway_attachment_id" {
  description = "Transit Gateway attachment ID for the VPN connection"
  value       = module.vpn.vpn_connection_transit_gateway_attachment_id
}

output "transit_gateway_attachment_id" {
  description = "ID of the Transit Gateway VPC attachment"
  value       = module.vpn.transit_gateway_attachment_id
}

output "transit_gateway_attachment_state" {
  description = "State of the Transit Gateway VPC attachment"
  value       = module.vpn.transit_gateway_attachment_state
}

output "vpn_connection_tunnel1_address" {
  description = "Public IP address of tunnel 1"
  value       = module.vpn.vpn_connection_tunnel1_address
}

output "vpn_connection_tunnel2_address" {
  description = "Public IP address of tunnel 2"
  value       = module.vpn.vpn_connection_tunnel2_address
}

# Custom Route Tables (v1.1.0 feature)
output "tgw_route_table_vpc_associations" {
  description = "Transit Gateway route table associations for VPC attachment"
  value       = module.vpn.tgw_route_table_vpc_associations
}

output "tgw_route_table_vpn_associations" {
  description = "Transit Gateway route table associations for VPN attachment"
  value       = module.vpn.tgw_route_table_vpn_associations
}

output "tgw_route_table_vpc_propagations" {
  description = "Transit Gateway route table propagations for VPC attachment"
  value       = module.vpn.tgw_route_table_vpc_propagations
}

output "tgw_route_table_vpn_propagations" {
  description = "Transit Gateway route table propagations for VPN attachment"
  value       = module.vpn.tgw_route_table_vpn_propagations
}

output "vpn_gateway_id" {
  description = "ID of the VPN Gateway"
  value       = module.vpn.vpn_gateway_id
}

output "vpn_connection_id" {
  description = "ID of the VPN Connection"
  value       = module.vpn.vpn_connection_id
}

output "vpn_connection_routes" {
  description = "Static routes configured for the VPN connection"
  value       = module.vpn.vpn_connection_routes
}

output "vpn_connection_tunnel1_address" {
  description = "Public IP address of tunnel 1"
  value       = module.vpn.vpn_connection_tunnel1_address
}

output "vpn_connection_tunnel2_address" {
  description = "Public IP address of tunnel 2"
  value       = module.vpn.vpn_connection_tunnel2_address
}

output "vpn_gateway_route_propagation_private" {
  description = "Private route table IDs with VPN route propagation"
  value       = module.vpn.vpn_gateway_route_propagation_private
}

output "vpn_gateway_route_propagation_database" {
  description = "Database route table IDs with VPN route propagation"
  value       = module.vpn.vpn_gateway_route_propagation_database
}

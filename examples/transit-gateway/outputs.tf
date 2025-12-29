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

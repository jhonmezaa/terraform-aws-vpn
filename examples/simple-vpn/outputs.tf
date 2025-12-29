output "vpn_gateway_id" {
  description = "ID of the VPN Gateway"
  value       = module.vpn.vpn_gateway_id
}

output "customer_gateway_id" {
  description = "ID of the Customer Gateway"
  value       = module.vpn.customer_gateway_id
}

output "vpn_connection_id" {
  description = "ID of the VPN Connection"
  value       = module.vpn.vpn_connection_id
}

output "vpn_connection_tunnel1_address" {
  description = "Public IP address of tunnel 1"
  value       = module.vpn.vpn_connection_tunnel1_address
}

output "vpn_connection_tunnel2_address" {
  description = "Public IP address of tunnel 2"
  value       = module.vpn.vpn_connection_tunnel2_address
}

output "vpn_connection_tunnel1_preshared_key" {
  description = "Preshared key for tunnel 1"
  value       = module.vpn.vpn_connection_tunnel1_preshared_key
  sensitive   = true
}

output "vpn_connection_tunnel2_preshared_key" {
  description = "Preshared key for tunnel 2"
  value       = module.vpn.vpn_connection_tunnel2_preshared_key
  sensitive   = true
}

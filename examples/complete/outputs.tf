################################################################################
# VPN Gateway Outputs
################################################################################

output "vpn_gateway_id" {
  description = "ID of the VPN Gateway"
  value       = module.vpn.vpn_gateway_id
}

output "vpn_gateway_arn" {
  description = "ARN of the VPN Gateway"
  value       = module.vpn.vpn_gateway_arn
}

output "vpn_gateway_amazon_side_asn" {
  description = "Amazon side ASN of the VPN Gateway"
  value       = module.vpn.vpn_gateway_amazon_side_asn
}

################################################################################
# Customer Gateway Outputs
################################################################################

output "customer_gateway_id" {
  description = "ID of the Customer Gateway"
  value       = module.vpn.customer_gateway_id
}

output "customer_gateway_arn" {
  description = "ARN of the Customer Gateway"
  value       = module.vpn.customer_gateway_arn
}

output "customer_gateway_bgp_asn" {
  description = "BGP ASN of the Customer Gateway"
  value       = module.vpn.customer_gateway_bgp_asn
}

################################################################################
# VPN Connection Outputs
################################################################################

output "vpn_connection_id" {
  description = "ID of the VPN Connection"
  value       = module.vpn.vpn_connection_id
}

output "vpn_connection_arn" {
  description = "ARN of the VPN Connection"
  value       = module.vpn.vpn_connection_arn
}

output "vpn_connection_type" {
  description = "Type of VPN connection"
  value       = module.vpn.vpn_connection_type
}

################################################################################
# Tunnel 1 Outputs
################################################################################

output "vpn_connection_tunnel1_address" {
  description = "Public IP address of tunnel 1"
  value       = module.vpn.vpn_connection_tunnel1_address
}

output "vpn_connection_tunnel1_cgw_inside_address" {
  description = "Link-local address of tunnel 1 (Customer Gateway side)"
  value       = module.vpn.vpn_connection_tunnel1_cgw_inside_address
}

output "vpn_connection_tunnel1_vgw_inside_address" {
  description = "Link-local address of tunnel 1 (VPN Gateway side)"
  value       = module.vpn.vpn_connection_tunnel1_vgw_inside_address
}

output "vpn_connection_tunnel1_preshared_key" {
  description = "Preshared key for tunnel 1"
  value       = module.vpn.vpn_connection_tunnel1_preshared_key
  sensitive   = true
}

output "vpn_connection_tunnel1_bgp_asn" {
  description = "BGP ASN for tunnel 1"
  value       = module.vpn.vpn_connection_tunnel1_bgp_asn
}

output "vpn_connection_tunnel1_bgp_holdtime" {
  description = "BGP holdtime for tunnel 1"
  value       = module.vpn.vpn_connection_tunnel1_bgp_holdtime
}

################################################################################
# Tunnel 2 Outputs
################################################################################

output "vpn_connection_tunnel2_address" {
  description = "Public IP address of tunnel 2"
  value       = module.vpn.vpn_connection_tunnel2_address
}

output "vpn_connection_tunnel2_cgw_inside_address" {
  description = "Link-local address of tunnel 2 (Customer Gateway side)"
  value       = module.vpn.vpn_connection_tunnel2_cgw_inside_address
}

output "vpn_connection_tunnel2_vgw_inside_address" {
  description = "Link-local address of tunnel 2 (VPN Gateway side)"
  value       = module.vpn.vpn_connection_tunnel2_vgw_inside_address
}

output "vpn_connection_tunnel2_preshared_key" {
  description = "Preshared key for tunnel 2"
  value       = module.vpn.vpn_connection_tunnel2_preshared_key
  sensitive   = true
}

output "vpn_connection_tunnel2_bgp_asn" {
  description = "BGP ASN for tunnel 2"
  value       = module.vpn.vpn_connection_tunnel2_bgp_asn
}

output "vpn_connection_tunnel2_bgp_holdtime" {
  description = "BGP holdtime for tunnel 2"
  value       = module.vpn.vpn_connection_tunnel2_bgp_holdtime
}

################################################################################
# Route Propagation Outputs
################################################################################

output "vpn_gateway_route_propagation_private" {
  description = "Private route table IDs with VPN route propagation"
  value       = module.vpn.vpn_gateway_route_propagation_private
}

output "vpn_gateway_route_propagation_public" {
  description = "Public route table IDs with VPN route propagation"
  value       = module.vpn.vpn_gateway_route_propagation_public
}

output "vpn_gateway_route_propagation_database" {
  description = "Database route table IDs with VPN route propagation"
  value       = module.vpn.vpn_gateway_route_propagation_database
}

output "vpn_gateway_route_propagation_intra" {
  description = "Intra route table IDs with VPN route propagation"
  value       = module.vpn.vpn_gateway_route_propagation_intra
}

################################################################################
# CloudWatch Log Groups
################################################################################

output "tunnel1_cloudwatch_log_group_name" {
  description = "Name of CloudWatch log group for tunnel 1"
  value       = aws_cloudwatch_log_group.tunnel1.name
}

output "tunnel1_cloudwatch_log_group_arn" {
  description = "ARN of CloudWatch log group for tunnel 1"
  value       = aws_cloudwatch_log_group.tunnel1.arn
}

output "tunnel2_cloudwatch_log_group_name" {
  description = "Name of CloudWatch log group for tunnel 2"
  value       = aws_cloudwatch_log_group.tunnel2.name
}

output "tunnel2_cloudwatch_log_group_arn" {
  description = "ARN of CloudWatch log group for tunnel 2"
  value       = aws_cloudwatch_log_group.tunnel2.arn
}

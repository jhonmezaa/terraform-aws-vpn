################################################################################
# VPN Gateway Outputs
################################################################################

output "vpn_gateway_id" {
  description = "ID of the VPN Gateway"
  value       = try(aws_vpn_gateway.this[0].id, var.vpn_gateway_id, null)
}

output "vpn_gateway_arn" {
  description = "ARN of the VPN Gateway"
  value       = try(aws_vpn_gateway.this[0].arn, null)
}

output "vpn_gateway_amazon_side_asn" {
  description = "The Autonomous System Number (ASN) for the Amazon side of the gateway"
  value       = try(aws_vpn_gateway.this[0].amazon_side_asn, null)
}

################################################################################
# Customer Gateway Outputs
################################################################################

output "customer_gateway_id" {
  description = "ID of the Customer Gateway"
  value       = try(aws_customer_gateway.this[0].id, var.customer_gateway_id, null)
}

output "customer_gateway_arn" {
  description = "ARN of the Customer Gateway"
  value       = try(aws_customer_gateway.this[0].arn, null)
}

output "customer_gateway_bgp_asn" {
  description = "BGP ASN of the Customer Gateway"
  value       = try(aws_customer_gateway.this[0].bgp_asn, null)
}

output "customer_gateway_ip_address" {
  description = "IP address of the Customer Gateway"
  value       = try(aws_customer_gateway.this[0].ip_address, null)
}

################################################################################
# VPN Connection Outputs
################################################################################

output "vpn_connection_id" {
  description = "ID of the VPN Connection"
  value       = try(aws_vpn_connection.this[0].id, null)
}

output "vpn_connection_arn" {
  description = "ARN of the VPN Connection"
  value       = try(aws_vpn_connection.this[0].arn, null)
}

output "vpn_connection_customer_gateway_configuration" {
  description = "The configuration information for the VPN connection's customer gateway (in the native XML format)"
  value       = try(aws_vpn_connection.this[0].customer_gateway_configuration, null)
  sensitive   = true
}

output "vpn_connection_type" {
  description = "The type of VPN connection"
  value       = try(aws_vpn_connection.this[0].type, null)
}

output "vpn_connection_static_routes_only" {
  description = "Whether the VPN connection uses static routes exclusively"
  value       = try(aws_vpn_connection.this[0].static_routes_only, null)
}

output "vpn_connection_enable_acceleration" {
  description = "Indicate whether to enable acceleration for the VPN connection"
  value       = try(aws_vpn_connection.this[0].enable_acceleration, null)
}

output "vpn_connection_transit_gateway_attachment_id" {
  description = "When associated with a Transit Gateway, the attachment ID"
  value       = try(aws_vpn_connection.this[0].transit_gateway_attachment_id, null)
}

output "vpn_connection_core_network_arn" {
  description = "The ARN of the core network"
  value       = try(aws_vpn_connection.this[0].core_network_arn, null)
}

output "vpn_connection_core_network_attachment_arn" {
  description = "The ARN of the core network attachment"
  value       = try(aws_vpn_connection.this[0].core_network_attachment_arn, null)
}

################################################################################
# Tunnel 1 Outputs
################################################################################

output "vpn_connection_tunnel1_address" {
  description = "The public IP address of the first VPN tunnel"
  value       = try(aws_vpn_connection.this[0].tunnel1_address, null)
}

output "vpn_connection_tunnel1_cgw_inside_address" {
  description = "The RFC 6890 link-local address of the first VPN tunnel (Customer Gateway Side)"
  value       = try(aws_vpn_connection.this[0].tunnel1_cgw_inside_address, null)
}

output "vpn_connection_tunnel1_vgw_inside_address" {
  description = "The RFC 6890 link-local address of the first VPN tunnel (VPN Gateway Side)"
  value       = try(aws_vpn_connection.this[0].tunnel1_vgw_inside_address, null)
}

output "vpn_connection_tunnel1_preshared_key" {
  description = "The preshared key of the first VPN tunnel"
  value       = try(aws_vpn_connection.this[0].tunnel1_preshared_key, null)
  sensitive   = true
}

output "vpn_connection_tunnel1_bgp_asn" {
  description = "The bgp asn number of the first VPN tunnel"
  value       = try(aws_vpn_connection.this[0].tunnel1_bgp_asn, null)
}

output "vpn_connection_tunnel1_bgp_holdtime" {
  description = "The bgp holdtime of the first VPN tunnel"
  value       = try(aws_vpn_connection.this[0].tunnel1_bgp_holdtime, null)
}

################################################################################
# Tunnel 2 Outputs
################################################################################

output "vpn_connection_tunnel2_address" {
  description = "The public IP address of the second VPN tunnel"
  value       = try(aws_vpn_connection.this[0].tunnel2_address, null)
}

output "vpn_connection_tunnel2_cgw_inside_address" {
  description = "The RFC 6890 link-local address of the second VPN tunnel (Customer Gateway Side)"
  value       = try(aws_vpn_connection.this[0].tunnel2_cgw_inside_address, null)
}

output "vpn_connection_tunnel2_vgw_inside_address" {
  description = "The RFC 6890 link-local address of the second VPN tunnel (VPN Gateway Side)"
  value       = try(aws_vpn_connection.this[0].tunnel2_vgw_inside_address, null)
}

output "vpn_connection_tunnel2_preshared_key" {
  description = "The preshared key of the second VPN tunnel"
  value       = try(aws_vpn_connection.this[0].tunnel2_preshared_key, null)
  sensitive   = true
}

output "vpn_connection_tunnel2_bgp_asn" {
  description = "The bgp asn number of the second VPN tunnel"
  value       = try(aws_vpn_connection.this[0].tunnel2_bgp_asn, null)
}

output "vpn_connection_tunnel2_bgp_holdtime" {
  description = "The bgp holdtime of the second VPN tunnel"
  value       = try(aws_vpn_connection.this[0].tunnel2_bgp_holdtime, null)
}

################################################################################
# Static Route Outputs
################################################################################

output "vpn_connection_routes" {
  description = "Static routes associated with the VPN connection"
  value = {
    for k, v in aws_vpn_connection_route.this : k => {
      destination_cidr_block = v.destination_cidr_block
      vpn_connection_id      = v.vpn_connection_id
    }
  }
}

################################################################################
# Transit Gateway Outputs
################################################################################

output "transit_gateway_attachment_id" {
  description = "ID of the Transit Gateway VPC attachment"
  value       = try(aws_ec2_transit_gateway_vpc_attachment.this[0].id, null)
}

output "transit_gateway_attachment_state" {
  description = "State of the Transit Gateway VPC attachment"
  value       = try(aws_ec2_transit_gateway_vpc_attachment.this[0].id, null) != null ? "available" : null
}

################################################################################
# Route Propagation Outputs
################################################################################

output "vpn_gateway_route_propagation_private" {
  description = "Private route table IDs with VPN route propagation enabled"
  value       = [for k, v in aws_vpn_gateway_route_propagation.private : v.route_table_id]
}

output "vpn_gateway_route_propagation_public" {
  description = "Public route table IDs with VPN route propagation enabled"
  value       = [for k, v in aws_vpn_gateway_route_propagation.public : v.route_table_id]
}

output "vpn_gateway_route_propagation_intra" {
  description = "Intra route table IDs with VPN route propagation enabled"
  value       = [for k, v in aws_vpn_gateway_route_propagation.intra : v.route_table_id]
}

output "vpn_gateway_route_propagation_database" {
  description = "Database route table IDs with VPN route propagation enabled"
  value       = [for k, v in aws_vpn_gateway_route_propagation.database : v.route_table_id]
}

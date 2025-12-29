################################################################################
# Simple VPN Gateway Example
################################################################################

module "vpn" {
  source = "../../vpn"

  # General
  account_name = var.account_name
  project_name = var.project_name
  tags_common  = var.tags_common

  # VPN Gateway
  create_vpn_gateway = true
  vpc_id             = var.vpc_id
  amazon_side_asn    = 64512

  # Customer Gateway
  customer_gateway_bgp_asn    = 65000
  customer_gateway_ip_address = var.customer_gateway_ip_address

  # VPN Connection - use BGP dynamic routing
  static_routes_only = false

  # Route Propagation
  propagate_private_route_tables_vgw = true
  private_route_table_ids            = var.private_route_table_ids
}

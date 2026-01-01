################################################################################
# Transit Gateway VPN Example
################################################################################

module "vpn" {
  source = "../../vpn"

  # General
  account_name = var.account_name
  project_name = var.project_name
  tags_common  = var.tags_common

  # VPN Gateway - not created when using Transit Gateway
  create_vpn_gateway = true
  vpc_id             = var.vpc_id

  # Customer Gateway
  customer_gateway_bgp_asn    = 65000
  customer_gateway_ip_address = var.customer_gateway_ip_address

  # VPN Connection via Transit Gateway
  transit_gateway_id         = var.transit_gateway_id
  transit_gateway_subnet_ids = var.transit_gateway_subnet_ids

  # Transit Gateway VPC Attachment Configuration
  transit_gateway_dns_support            = "enable"
  transit_gateway_ipv6_support           = "disable"
  transit_gateway_appliance_mode_support = "disable"

  # Option 1: Use default route table (commented out, showing both options)
  # transit_gateway_default_route_table_association = true
  # transit_gateway_default_route_table_propagation = true

  # Option 2: Use custom route tables (new feature in v1.1.0)
  transit_gateway_route_table_association_ids = var.transit_gateway_route_table_ids
  transit_gateway_route_table_propagation_ids = var.transit_gateway_route_table_ids

  # VPN Connection - use BGP dynamic routing
  static_routes_only = false

  # Tunnel Inside CIDR - Custom ranges (optional, AWS auto-assigns if not specified)
  # Must be in 169.254.0.0/16 range with /30 netmask
  tunnel1_inside_cidr = "169.254.100.0/30" # AWS: .1, Customer: .2
  tunnel2_inside_cidr = "169.254.100.4/30" # AWS: .5, Customer: .6
}

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
  transit_gateway_dns_support                     = "enable"
  transit_gateway_ipv6_support                    = "disable"
  transit_gateway_appliance_mode_support          = "disable"
  transit_gateway_default_route_table_association = true
  transit_gateway_default_route_table_propagation = true

  # VPN Connection - use BGP dynamic routing
  static_routes_only = false
}

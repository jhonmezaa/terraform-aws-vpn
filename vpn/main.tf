################################################################################
# VPN Gateway
################################################################################

resource "aws_vpn_gateway" "this" {
  count = local.create_vpn_gateway ? 1 : 0

  vpc_id            = var.vpc_id
  amazon_side_asn   = var.amazon_side_asn
  availability_zone = var.vpn_gateway_az

  tags = local.vpn_gateway_tags
}

# Attach existing VPN Gateway to VPC
resource "aws_vpn_gateway_attachment" "this" {
  count = var.create_vpn_gateway && var.vpn_gateway_id != null ? 1 : 0

  vpc_id         = var.vpc_id
  vpn_gateway_id = var.vpn_gateway_id
}

################################################################################
# Customer Gateway
################################################################################

resource "aws_customer_gateway" "this" {
  count = local.create_customer_gateway ? 1 : 0

  bgp_asn         = var.customer_gateway_bgp_asn
  ip_address      = var.customer_gateway_ip_address
  type            = "ipsec.1"
  certificate_arn = var.customer_gateway_certificate_arn
  device_name     = var.customer_gateway_device_name

  tags = local.customer_gateway_tags
}

################################################################################
# VPN Connection
################################################################################

resource "aws_vpn_connection" "this" {
  count = local.create_vpn_connection ? 1 : 0

  vpn_gateway_id      = var.transit_gateway_id == null ? local.vpn_gateway_id : null
  customer_gateway_id = local.customer_gateway_id
  transit_gateway_id  = var.transit_gateway_id
  type                = "ipsec.1"

  static_routes_only                      = var.static_routes_only
  enable_acceleration                     = var.enable_vpn_acceleration
  local_ipv4_network_cidr                 = var.local_ipv4_network_cidr
  remote_ipv4_network_cidr                = var.remote_ipv4_network_cidr
  local_ipv6_network_cidr                 = var.local_ipv6_network_cidr
  remote_ipv6_network_cidr                = var.remote_ipv6_network_cidr
  outside_ip_address_type                 = var.outside_ip_address_type
  transport_transit_gateway_attachment_id = var.transport_transit_gateway_attachment_id
  tunnel_inside_ip_version                = var.tunnel_inside_ip_version

  # Tunnel 1 Configuration
  dynamic "tunnel1_log_options" {
    for_each = var.tunnel1_cloudwatch_log_enabled ? [1] : []
    content {
      cloudwatch_log_options {
        log_enabled       = var.tunnel1_cloudwatch_log_enabled
        log_group_arn     = var.tunnel1_cloudwatch_log_group_arn
        log_output_format = var.tunnel1_cloudwatch_log_output_format
      }
    }
  }

  tunnel1_inside_cidr                     = var.tunnel1_inside_cidr
  tunnel1_inside_ipv6_cidr                = var.tunnel1_inside_ipv6_cidr
  tunnel1_preshared_key                   = var.tunnel1_preshared_key
  tunnel1_dpd_timeout_action              = var.tunnel1_dpd_timeout_action
  tunnel1_dpd_timeout_seconds             = var.tunnel1_dpd_timeout_seconds
  tunnel1_enable_tunnel_lifecycle_control = var.tunnel1_enable_tunnel_lifecycle_control
  tunnel1_ike_versions                    = var.tunnel1_ike_versions
  tunnel1_startup_action                  = var.tunnel1_startup_action
  tunnel1_rekey_fuzz_percentage           = var.tunnel1_rekey_fuzz_percentage
  tunnel1_rekey_margin_time_seconds       = var.tunnel1_rekey_margin_time_seconds
  tunnel1_replay_window_size              = var.tunnel1_replay_window_size

  # Tunnel 1 Phase 1
  tunnel1_phase1_dh_group_numbers      = var.tunnel1_phase1_dh_group_numbers
  tunnel1_phase1_encryption_algorithms = var.tunnel1_phase1_encryption_algorithms
  tunnel1_phase1_integrity_algorithms  = var.tunnel1_phase1_integrity_algorithms
  tunnel1_phase1_lifetime_seconds      = var.tunnel1_phase1_lifetime_seconds

  # Tunnel 1 Phase 2
  tunnel1_phase2_dh_group_numbers      = var.tunnel1_phase2_dh_group_numbers
  tunnel1_phase2_encryption_algorithms = var.tunnel1_phase2_encryption_algorithms
  tunnel1_phase2_integrity_algorithms  = var.tunnel1_phase2_integrity_algorithms
  tunnel1_phase2_lifetime_seconds      = var.tunnel1_phase2_lifetime_seconds

  # Tunnel 2 Configuration
  dynamic "tunnel2_log_options" {
    for_each = var.tunnel2_cloudwatch_log_enabled ? [1] : []
    content {
      cloudwatch_log_options {
        log_enabled       = var.tunnel2_cloudwatch_log_enabled
        log_group_arn     = var.tunnel2_cloudwatch_log_group_arn
        log_output_format = var.tunnel2_cloudwatch_log_output_format
      }
    }
  }

  tunnel2_inside_cidr                     = var.tunnel2_inside_cidr
  tunnel2_inside_ipv6_cidr                = var.tunnel2_inside_ipv6_cidr
  tunnel2_preshared_key                   = var.tunnel2_preshared_key
  tunnel2_dpd_timeout_action              = var.tunnel2_dpd_timeout_action
  tunnel2_dpd_timeout_seconds             = var.tunnel2_dpd_timeout_seconds
  tunnel2_enable_tunnel_lifecycle_control = var.tunnel2_enable_tunnel_lifecycle_control
  tunnel2_ike_versions                    = var.tunnel2_ike_versions
  tunnel2_startup_action                  = var.tunnel2_startup_action
  tunnel2_rekey_fuzz_percentage           = var.tunnel2_rekey_fuzz_percentage
  tunnel2_rekey_margin_time_seconds       = var.tunnel2_rekey_margin_time_seconds
  tunnel2_replay_window_size              = var.tunnel2_replay_window_size

  # Tunnel 2 Phase 1
  tunnel2_phase1_dh_group_numbers      = var.tunnel2_phase1_dh_group_numbers
  tunnel2_phase1_encryption_algorithms = var.tunnel2_phase1_encryption_algorithms
  tunnel2_phase1_integrity_algorithms  = var.tunnel2_phase1_integrity_algorithms
  tunnel2_phase1_lifetime_seconds      = var.tunnel2_phase1_lifetime_seconds

  # Tunnel 2 Phase 2
  tunnel2_phase2_dh_group_numbers      = var.tunnel2_phase2_dh_group_numbers
  tunnel2_phase2_encryption_algorithms = var.tunnel2_phase2_encryption_algorithms
  tunnel2_phase2_integrity_algorithms  = var.tunnel2_phase2_integrity_algorithms
  tunnel2_phase2_lifetime_seconds      = var.tunnel2_phase2_lifetime_seconds

  tags = local.vpn_connection_tags
}

################################################################################
# Transit Gateway VPN Attachment
################################################################################

resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  count = local.create_transit_gateway_attachment ? 1 : 0

  subnet_ids         = var.transit_gateway_subnet_ids
  transit_gateway_id = var.transit_gateway_id
  vpc_id             = var.vpc_id

  dns_support                                     = var.transit_gateway_dns_support
  ipv6_support                                    = var.transit_gateway_ipv6_support
  appliance_mode_support                          = var.transit_gateway_appliance_mode_support
  transit_gateway_default_route_table_association = var.transit_gateway_default_route_table_association
  transit_gateway_default_route_table_propagation = var.transit_gateway_default_route_table_propagation

  tags = local.transit_gateway_attachment_tags
}

################################################################################
# Complete VPN Gateway Example - All Features
################################################################################

# CloudWatch Log Groups for VPN tunnel logging
resource "aws_cloudwatch_log_group" "tunnel1" {
  name              = "/aws/vpn/tunnel1-${var.account_name}-${var.project_name}"
  retention_in_days = 7

  tags = var.tags_common
}

resource "aws_cloudwatch_log_group" "tunnel2" {
  name              = "/aws/vpn/tunnel2-${var.account_name}-${var.project_name}"
  retention_in_days = 7

  tags = var.tags_common
}

module "vpn" {
  source = "../../vpn"

  # General
  account_name = var.account_name
  project_name = var.project_name
  tags_common  = var.tags_common

  # VPN Gateway
  create_vpn_gateway = true
  vpc_id             = var.vpc_id
  amazon_side_asn    = var.amazon_side_asn
  vpn_gateway_az     = var.vpn_gateway_az

  # Customer Gateway
  customer_gateway_bgp_asn     = var.customer_gateway_bgp_asn
  customer_gateway_ip_address  = var.customer_gateway_ip_address
  customer_gateway_device_name = var.customer_gateway_device_name

  # VPN Connection
  static_routes_only       = var.static_routes_only
  enable_vpn_acceleration  = var.enable_vpn_acceleration
  local_ipv4_network_cidr  = var.local_ipv4_network_cidr
  remote_ipv4_network_cidr = var.remote_ipv4_network_cidr
  tunnel_inside_ip_version = "ipv4"

  # Tunnel 1 Configuration
  tunnel1_inside_cidr                     = var.tunnel1_inside_cidr
  tunnel1_preshared_key                   = var.tunnel1_preshared_key
  tunnel1_dpd_timeout_action              = "restart"
  tunnel1_dpd_timeout_seconds             = 30
  tunnel1_enable_tunnel_lifecycle_control = false
  tunnel1_ike_versions                    = ["ikev2"]
  tunnel1_startup_action                  = "start"
  tunnel1_rekey_fuzz_percentage           = 100
  tunnel1_rekey_margin_time_seconds       = 540
  tunnel1_replay_window_size              = 1024

  # Tunnel 1 Phase 1 - Strong encryption
  tunnel1_phase1_dh_group_numbers      = [20, 21, 22, 23, 24]
  tunnel1_phase1_encryption_algorithms = ["AES256", "AES256-GCM-16"]
  tunnel1_phase1_integrity_algorithms  = ["SHA2-256", "SHA2-384", "SHA2-512"]
  tunnel1_phase1_lifetime_seconds      = 28800

  # Tunnel 1 Phase 2 - Strong encryption
  tunnel1_phase2_dh_group_numbers      = [20, 21, 22, 23, 24]
  tunnel1_phase2_encryption_algorithms = ["AES256", "AES256-GCM-16"]
  tunnel1_phase2_integrity_algorithms  = ["SHA2-256", "SHA2-384", "SHA2-512"]
  tunnel1_phase2_lifetime_seconds      = 3600

  # Tunnel 1 CloudWatch Logs
  tunnel1_cloudwatch_log_enabled       = true
  tunnel1_cloudwatch_log_group_arn     = aws_cloudwatch_log_group.tunnel1.arn
  tunnel1_cloudwatch_log_output_format = "json"

  # Tunnel 2 Configuration
  tunnel2_inside_cidr                     = var.tunnel2_inside_cidr
  tunnel2_preshared_key                   = var.tunnel2_preshared_key
  tunnel2_dpd_timeout_action              = "restart"
  tunnel2_dpd_timeout_seconds             = 30
  tunnel2_enable_tunnel_lifecycle_control = false
  tunnel2_ike_versions                    = ["ikev2"]
  tunnel2_startup_action                  = "start"
  tunnel2_rekey_fuzz_percentage           = 100
  tunnel2_rekey_margin_time_seconds       = 540
  tunnel2_replay_window_size              = 1024

  # Tunnel 2 Phase 1 - Strong encryption
  tunnel2_phase1_dh_group_numbers      = [20, 21, 22, 23, 24]
  tunnel2_phase1_encryption_algorithms = ["AES256", "AES256-GCM-16"]
  tunnel2_phase1_integrity_algorithms  = ["SHA2-256", "SHA2-384", "SHA2-512"]
  tunnel2_phase1_lifetime_seconds      = 28800

  # Tunnel 2 Phase 2 - Strong encryption
  tunnel2_phase2_dh_group_numbers      = [20, 21, 22, 23, 24]
  tunnel2_phase2_encryption_algorithms = ["AES256", "AES256-GCM-16"]
  tunnel2_phase2_integrity_algorithms  = ["SHA2-256", "SHA2-384", "SHA2-512"]
  tunnel2_phase2_lifetime_seconds      = 3600

  # Tunnel 2 CloudWatch Logs
  tunnel2_cloudwatch_log_enabled       = true
  tunnel2_cloudwatch_log_group_arn     = aws_cloudwatch_log_group.tunnel2.arn
  tunnel2_cloudwatch_log_output_format = "json"

  # Route Propagation to all route tables
  propagate_private_route_tables_vgw  = true
  propagate_public_route_tables_vgw   = true
  propagate_database_route_tables_vgw = true
  propagate_intra_route_tables_vgw    = true

  private_route_table_ids  = var.private_route_table_ids
  public_route_table_ids   = var.public_route_table_ids
  database_route_table_ids = var.database_route_table_ids
  intra_route_table_ids    = var.intra_route_table_ids

  # Tags
  vpn_gateway_tags = {
    Type = "production"
  }

  customer_gateway_tags = {
    Location = "on-premises-datacenter"
  }

  vpn_connection_tags = {
    HighAvailability = "true"
    Monitoring       = "enabled"
  }
}

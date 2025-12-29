################################################################################
# General Variables
################################################################################

variable "account_name" {
  description = "Account name for resource naming (e.g., 'prod', 'dev', 'staging')"
  type        = string
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "region_prefix" {
  description = "Region prefix override (auto-detected if not provided)"
  type        = string
  default     = null
}

variable "tags_common" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}

################################################################################
# VPN Gateway Variables
################################################################################

variable "create_vpn_gateway" {
  description = "Create VPN gateway and related resources"
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "VPC ID where VPN Gateway will be attached"
  type        = string
  default     = null
}

variable "vpn_gateway_id" {
  description = "ID of existing VPN Gateway to attach to VPC (if provided, no new VPN Gateway will be created)"
  type        = string
  default     = null
}

variable "amazon_side_asn" {
  description = "Private Autonomous System Number (ASN) for the Amazon side of a BGP session"
  type        = number
  default     = 64512

  validation {
    condition     = var.amazon_side_asn >= 64512 && var.amazon_side_asn <= 65534
    error_message = "Amazon side ASN must be in the private ASN range (64512-65534)."
  }
}

variable "vpn_gateway_az" {
  description = "Availability Zone for the VPN Gateway (optional)"
  type        = string
  default     = null
}

variable "vpn_gateway_tags" {
  description = "Additional tags for VPN Gateway"
  type        = map(string)
  default     = {}
}

################################################################################
# Customer Gateway Variables
################################################################################

variable "customer_gateway_id" {
  description = "ID of existing Customer Gateway (if provided, no new Customer Gateway will be created)"
  type        = string
  default     = null
}

variable "customer_gateway_bgp_asn" {
  description = "BGP ASN of the customer gateway"
  type        = number
  default     = null

  validation {
    condition     = var.customer_gateway_bgp_asn == null || (var.customer_gateway_bgp_asn >= 1 && var.customer_gateway_bgp_asn <= 4294967295)
    error_message = "Customer Gateway BGP ASN must be between 1 and 4294967295."
  }
}

variable "customer_gateway_ip_address" {
  description = "IP address of the customer gateway's external interface"
  type        = string
  default     = null
}

variable "customer_gateway_certificate_arn" {
  description = "ARN for customer gateway certificate"
  type        = string
  default     = null
}

variable "customer_gateway_device_name" {
  description = "Name for customer gateway device"
  type        = string
  default     = null
}

variable "customer_gateway_tags" {
  description = "Additional tags for Customer Gateway"
  type        = map(string)
  default     = {}
}

################################################################################
# VPN Connection Variables
################################################################################

variable "static_routes_only" {
  description = "Whether the VPN connection uses static routes (true) or BGP dynamic routing (false)"
  type        = bool
  default     = false
}

variable "static_routes_destinations" {
  description = "List of CIDR blocks for static routes (only used if static_routes_only is true)"
  type        = list(string)
  default     = null
}

variable "enable_vpn_acceleration" {
  description = "Enable VPN acceleration"
  type        = bool
  default     = false
}

variable "local_ipv4_network_cidr" {
  description = "IPv4 CIDR on the customer gateway (on-premises) side of the VPN connection"
  type        = string
  default     = "0.0.0.0/0"
}

variable "remote_ipv4_network_cidr" {
  description = "IPv4 CIDR on the AWS side of the VPN connection"
  type        = string
  default     = "0.0.0.0/0"
}

variable "local_ipv6_network_cidr" {
  description = "IPv6 CIDR on the customer gateway (on-premises) side of the VPN connection"
  type        = string
  default     = null
}

variable "remote_ipv6_network_cidr" {
  description = "IPv6 CIDR on the AWS side of the VPN connection"
  type        = string
  default     = null
}

variable "outside_ip_address_type" {
  description = "Indicates if a Public S2S VPN or Private S2S VPN over AWS Direct Connect. Valid values are 'PrivateIpv4' or 'PublicIpv4'"
  type        = string
  default     = "PublicIpv4"

  validation {
    condition     = contains(["PrivateIpv4", "PublicIpv4"], var.outside_ip_address_type)
    error_message = "Outside IP address type must be either 'PrivateIpv4' or 'PublicIpv4'."
  }
}

variable "transport_transit_gateway_attachment_id" {
  description = "The attachment ID of the Transit Gateway attachment to Direct Connect Gateway"
  type        = string
  default     = null
}

variable "tunnel_inside_ip_version" {
  description = "Indicate whether the VPN tunnels process IPv4 or IPv6 traffic. Valid values are ipv4 or ipv6"
  type        = string
  default     = "ipv4"

  validation {
    condition     = contains(["ipv4", "ipv6"], var.tunnel_inside_ip_version)
    error_message = "Tunnel inside IP version must be either 'ipv4' or 'ipv6'."
  }
}

variable "vpn_connection_tags" {
  description = "Additional tags for VPN Connection"
  type        = map(string)
  default     = {}
}

################################################################################
# Tunnel 1 Variables
################################################################################

variable "tunnel1_inside_cidr" {
  description = "CIDR block for tunnel 1 inside addresses"
  type        = string
  default     = null
}

variable "tunnel1_inside_ipv6_cidr" {
  description = "IPv6 CIDR block for tunnel 1 inside addresses"
  type        = string
  default     = null
}

variable "tunnel1_preshared_key" {
  description = "Preshared key for tunnel 1 (will be generated if not provided)"
  type        = string
  default     = null
  sensitive   = true
}

variable "tunnel1_dpd_timeout_action" {
  description = "Action to take after DPD timeout occurs for tunnel 1. Valid values are 'clear', 'none', or 'restart'"
  type        = string
  default     = "clear"

  validation {
    condition     = contains(["clear", "none", "restart"], var.tunnel1_dpd_timeout_action)
    error_message = "DPD timeout action must be 'clear', 'none', or 'restart'."
  }
}

variable "tunnel1_dpd_timeout_seconds" {
  description = "The number of seconds after which a DPD timeout occurs for tunnel 1"
  type        = number
  default     = 30

  validation {
    condition     = var.tunnel1_dpd_timeout_seconds >= 30
    error_message = "DPD timeout must be at least 30 seconds."
  }
}

variable "tunnel1_enable_tunnel_lifecycle_control" {
  description = "Turn on or off tunnel endpoint lifecycle control for tunnel 1"
  type        = bool
  default     = false
}

variable "tunnel1_ike_versions" {
  description = "IKE versions permitted for tunnel 1. Valid values are 'ikev1' or 'ikev2'"
  type        = list(string)
  default     = ["ikev1", "ikev2"]

  validation {
    condition     = alltrue([for v in var.tunnel1_ike_versions : contains(["ikev1", "ikev2"], v)])
    error_message = "IKE versions must be 'ikev1' or 'ikev2'."
  }
}

variable "tunnel1_startup_action" {
  description = "The action to take when the establishing the tunnel for tunnel 1. Valid values are 'add' or 'start'"
  type        = string
  default     = "add"

  validation {
    condition     = contains(["add", "start"], var.tunnel1_startup_action)
    error_message = "Startup action must be 'add' or 'start'."
  }
}

variable "tunnel1_rekey_fuzz_percentage" {
  description = "Percentage of rekey window for tunnel 1, during which rekey time is randomly selected"
  type        = number
  default     = 100

  validation {
    condition     = var.tunnel1_rekey_fuzz_percentage >= 0 && var.tunnel1_rekey_fuzz_percentage <= 100
    error_message = "Rekey fuzz percentage must be between 0 and 100."
  }
}

variable "tunnel1_rekey_margin_time_seconds" {
  description = "Margin time before rekey process starts for tunnel 1"
  type        = number
  default     = 540

  validation {
    condition     = var.tunnel1_rekey_margin_time_seconds >= 60 && var.tunnel1_rekey_margin_time_seconds <= 1800
    error_message = "Rekey margin time must be between 60 and 1800 seconds."
  }
}

variable "tunnel1_replay_window_size" {
  description = "Number of packets in an IKE replay window for tunnel 1"
  type        = number
  default     = 1024

  validation {
    condition     = var.tunnel1_replay_window_size >= 64 && var.tunnel1_replay_window_size <= 2048
    error_message = "Replay window size must be between 64 and 2048."
  }
}

# Tunnel 1 Phase 1
variable "tunnel1_phase1_dh_group_numbers" {
  description = "List of Diffie-Hellman group numbers permitted for tunnel 1 phase 1 IKE negotiations"
  type        = list(number)
  default     = [2, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24]
}

variable "tunnel1_phase1_encryption_algorithms" {
  description = "List of encryption algorithms permitted for tunnel 1 phase 1 IKE negotiations"
  type        = list(string)
  default     = ["AES128", "AES256", "AES128-GCM-16", "AES256-GCM-16"]
}

variable "tunnel1_phase1_integrity_algorithms" {
  description = "List of integrity algorithms permitted for tunnel 1 phase 1 IKE negotiations"
  type        = list(string)
  default     = ["SHA1", "SHA2-256", "SHA2-384", "SHA2-512"]
}

variable "tunnel1_phase1_lifetime_seconds" {
  description = "Lifetime for tunnel 1 phase 1 IKE negotiations, in seconds"
  type        = number
  default     = 28800

  validation {
    condition     = var.tunnel1_phase1_lifetime_seconds >= 900 && var.tunnel1_phase1_lifetime_seconds <= 28800
    error_message = "Phase 1 lifetime must be between 900 and 28800 seconds."
  }
}

# Tunnel 1 Phase 2
variable "tunnel1_phase2_dh_group_numbers" {
  description = "List of Diffie-Hellman group numbers permitted for tunnel 1 phase 2 IKE negotiations"
  type        = list(number)
  default     = [2, 5, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24]
}

variable "tunnel1_phase2_encryption_algorithms" {
  description = "List of encryption algorithms permitted for tunnel 1 phase 2 IKE negotiations"
  type        = list(string)
  default     = ["AES128", "AES256", "AES128-GCM-16", "AES256-GCM-16"]
}

variable "tunnel1_phase2_integrity_algorithms" {
  description = "List of integrity algorithms permitted for tunnel 1 phase 2 IKE negotiations"
  type        = list(string)
  default     = ["SHA1", "SHA2-256", "SHA2-384", "SHA2-512"]
}

variable "tunnel1_phase2_lifetime_seconds" {
  description = "Lifetime for tunnel 1 phase 2 IKE negotiations, in seconds"
  type        = number
  default     = 3600

  validation {
    condition     = var.tunnel1_phase2_lifetime_seconds >= 900 && var.tunnel1_phase2_lifetime_seconds <= 3600
    error_message = "Phase 2 lifetime must be between 900 and 3600 seconds."
  }
}

# Tunnel 1 CloudWatch Logs
variable "tunnel1_cloudwatch_log_enabled" {
  description = "Enable CloudWatch logs for tunnel 1"
  type        = bool
  default     = false
}

variable "tunnel1_cloudwatch_log_group_arn" {
  description = "CloudWatch log group ARN for tunnel 1"
  type        = string
  default     = null
}

variable "tunnel1_cloudwatch_log_output_format" {
  description = "CloudWatch log output format for tunnel 1. Valid values are 'json' or 'text'"
  type        = string
  default     = "json"

  validation {
    condition     = contains(["json", "text"], var.tunnel1_cloudwatch_log_output_format)
    error_message = "Log output format must be 'json' or 'text'."
  }
}

################################################################################
# Tunnel 2 Variables
################################################################################

variable "tunnel2_inside_cidr" {
  description = "CIDR block for tunnel 2 inside addresses"
  type        = string
  default     = null
}

variable "tunnel2_inside_ipv6_cidr" {
  description = "IPv6 CIDR block for tunnel 2 inside addresses"
  type        = string
  default     = null
}

variable "tunnel2_preshared_key" {
  description = "Preshared key for tunnel 2 (will be generated if not provided)"
  type        = string
  default     = null
  sensitive   = true
}

variable "tunnel2_dpd_timeout_action" {
  description = "Action to take after DPD timeout occurs for tunnel 2. Valid values are 'clear', 'none', or 'restart'"
  type        = string
  default     = "clear"

  validation {
    condition     = contains(["clear", "none", "restart"], var.tunnel2_dpd_timeout_action)
    error_message = "DPD timeout action must be 'clear', 'none', or 'restart'."
  }
}

variable "tunnel2_dpd_timeout_seconds" {
  description = "The number of seconds after which a DPD timeout occurs for tunnel 2"
  type        = number
  default     = 30

  validation {
    condition     = var.tunnel2_dpd_timeout_seconds >= 30
    error_message = "DPD timeout must be at least 30 seconds."
  }
}

variable "tunnel2_enable_tunnel_lifecycle_control" {
  description = "Turn on or off tunnel endpoint lifecycle control for tunnel 2"
  type        = bool
  default     = false
}

variable "tunnel2_ike_versions" {
  description = "IKE versions permitted for tunnel 2. Valid values are 'ikev1' or 'ikev2'"
  type        = list(string)
  default     = ["ikev1", "ikev2"]

  validation {
    condition     = alltrue([for v in var.tunnel2_ike_versions : contains(["ikev1", "ikev2"], v)])
    error_message = "IKE versions must be 'ikev1' or 'ikev2'."
  }
}

variable "tunnel2_startup_action" {
  description = "The action to take when the establishing the tunnel for tunnel 2. Valid values are 'add' or 'start'"
  type        = string
  default     = "add"

  validation {
    condition     = contains(["add", "start"], var.tunnel2_startup_action)
    error_message = "Startup action must be 'add' or 'start'."
  }
}

variable "tunnel2_rekey_fuzz_percentage" {
  description = "Percentage of rekey window for tunnel 2, during which rekey time is randomly selected"
  type        = number
  default     = 100

  validation {
    condition     = var.tunnel2_rekey_fuzz_percentage >= 0 && var.tunnel2_rekey_fuzz_percentage <= 100
    error_message = "Rekey fuzz percentage must be between 0 and 100."
  }
}

variable "tunnel2_rekey_margin_time_seconds" {
  description = "Margin time before rekey process starts for tunnel 2"
  type        = number
  default     = 540

  validation {
    condition     = var.tunnel2_rekey_margin_time_seconds >= 60 && var.tunnel2_rekey_margin_time_seconds <= 1800
    error_message = "Rekey margin time must be between 60 and 1800 seconds."
  }
}

variable "tunnel2_replay_window_size" {
  description = "Number of packets in an IKE replay window for tunnel 2"
  type        = number
  default     = 1024

  validation {
    condition     = var.tunnel2_replay_window_size >= 64 && var.tunnel2_replay_window_size <= 2048
    error_message = "Replay window size must be between 64 and 2048."
  }
}

# Tunnel 2 Phase 1
variable "tunnel2_phase1_dh_group_numbers" {
  description = "List of Diffie-Hellman group numbers permitted for tunnel 2 phase 1 IKE negotiations"
  type        = list(number)
  default     = [2, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24]
}

variable "tunnel2_phase1_encryption_algorithms" {
  description = "List of encryption algorithms permitted for tunnel 2 phase 1 IKE negotiations"
  type        = list(string)
  default     = ["AES128", "AES256", "AES128-GCM-16", "AES256-GCM-16"]
}

variable "tunnel2_phase1_integrity_algorithms" {
  description = "List of integrity algorithms permitted for tunnel 2 phase 1 IKE negotiations"
  type        = list(string)
  default     = ["SHA1", "SHA2-256", "SHA2-384", "SHA2-512"]
}

variable "tunnel2_phase1_lifetime_seconds" {
  description = "Lifetime for tunnel 2 phase 1 IKE negotiations, in seconds"
  type        = number
  default     = 28800

  validation {
    condition     = var.tunnel2_phase1_lifetime_seconds >= 900 && var.tunnel2_phase1_lifetime_seconds <= 28800
    error_message = "Phase 1 lifetime must be between 900 and 28800 seconds."
  }
}

# Tunnel 2 Phase 2
variable "tunnel2_phase2_dh_group_numbers" {
  description = "List of Diffie-Hellman group numbers permitted for tunnel 2 phase 2 IKE negotiations"
  type        = list(number)
  default     = [2, 5, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24]
}

variable "tunnel2_phase2_encryption_algorithms" {
  description = "List of encryption algorithms permitted for tunnel 2 phase 2 IKE negotiations"
  type        = list(string)
  default     = ["AES128", "AES256", "AES128-GCM-16", "AES256-GCM-16"]
}

variable "tunnel2_phase2_integrity_algorithms" {
  description = "List of integrity algorithms permitted for tunnel 2 phase 2 IKE negotiations"
  type        = list(string)
  default     = ["SHA1", "SHA2-256", "SHA2-384", "SHA2-512"]
}

variable "tunnel2_phase2_lifetime_seconds" {
  description = "Lifetime for tunnel 2 phase 2 IKE negotiations, in seconds"
  type        = number
  default     = 3600

  validation {
    condition     = var.tunnel2_phase2_lifetime_seconds >= 900 && var.tunnel2_phase2_lifetime_seconds <= 3600
    error_message = "Phase 2 lifetime must be between 900 and 3600 seconds."
  }
}

# Tunnel 2 CloudWatch Logs
variable "tunnel2_cloudwatch_log_enabled" {
  description = "Enable CloudWatch logs for tunnel 2"
  type        = bool
  default     = false
}

variable "tunnel2_cloudwatch_log_group_arn" {
  description = "CloudWatch log group ARN for tunnel 2"
  type        = string
  default     = null
}

variable "tunnel2_cloudwatch_log_output_format" {
  description = "CloudWatch log output format for tunnel 2. Valid values are 'json' or 'text'"
  type        = string
  default     = "json"

  validation {
    condition     = contains(["json", "text"], var.tunnel2_cloudwatch_log_output_format)
    error_message = "Log output format must be 'json' or 'text'."
  }
}

################################################################################
# Transit Gateway Variables
################################################################################

variable "transit_gateway_id" {
  description = "ID of the Transit Gateway to attach VPN to (if using Transit Gateway instead of VPN Gateway)"
  type        = string
  default     = null
}

variable "transit_gateway_subnet_ids" {
  description = "Subnet IDs for Transit Gateway VPC attachment"
  type        = list(string)
  default     = []
}

variable "transit_gateway_dns_support" {
  description = "Whether DNS support is enabled for Transit Gateway VPC attachment"
  type        = string
  default     = "enable"

  validation {
    condition     = contains(["enable", "disable"], var.transit_gateway_dns_support)
    error_message = "Transit Gateway DNS support must be 'enable' or 'disable'."
  }
}

variable "transit_gateway_ipv6_support" {
  description = "Whether IPv6 support is enabled for Transit Gateway VPC attachment"
  type        = string
  default     = "disable"

  validation {
    condition     = contains(["enable", "disable"], var.transit_gateway_ipv6_support)
    error_message = "Transit Gateway IPv6 support must be 'enable' or 'disable'."
  }
}

variable "transit_gateway_appliance_mode_support" {
  description = "Whether appliance mode support is enabled for Transit Gateway VPC attachment"
  type        = string
  default     = "disable"

  validation {
    condition     = contains(["enable", "disable"], var.transit_gateway_appliance_mode_support)
    error_message = "Transit Gateway appliance mode support must be 'enable' or 'disable'."
  }
}

variable "transit_gateway_default_route_table_association" {
  description = "Whether the VPC attachment is associated with the default Transit Gateway route table"
  type        = bool
  default     = true
}

variable "transit_gateway_default_route_table_propagation" {
  description = "Whether the VPC attachment propagates routes to the default Transit Gateway route table"
  type        = bool
  default     = true
}

variable "transit_gateway_attachment_tags" {
  description = "Additional tags for Transit Gateway VPC attachment"
  type        = map(string)
  default     = {}
}

################################################################################
# Route Propagation Variables
################################################################################

variable "propagate_private_route_tables_vgw" {
  description = "Enable route propagation to private route tables"
  type        = bool
  default     = false
}

variable "propagate_public_route_tables_vgw" {
  description = "Enable route propagation to public route tables"
  type        = bool
  default     = false
}

variable "propagate_intra_route_tables_vgw" {
  description = "Enable route propagation to intra route tables"
  type        = bool
  default     = false
}

variable "propagate_database_route_tables_vgw" {
  description = "Enable route propagation to database route tables"
  type        = bool
  default     = false
}

variable "private_route_table_ids" {
  description = "List of private route table IDs for VPN route propagation"
  type        = list(string)
  default     = []
}

variable "public_route_table_ids" {
  description = "List of public route table IDs for VPN route propagation"
  type        = list(string)
  default     = []
}

variable "intra_route_table_ids" {
  description = "List of intra route table IDs for VPN route propagation"
  type        = list(string)
  default     = []
}

variable "database_route_table_ids" {
  description = "List of database route table IDs for VPN route propagation"
  type        = list(string)
  default     = []
}

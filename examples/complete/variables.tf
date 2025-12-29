variable "account_name" {
  description = "Account name for resource naming"
  type        = string
  default     = "prod"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "complete-vpn"
}

variable "vpc_id" {
  description = "VPC ID where VPN Gateway will be attached"
  type        = string
}

variable "amazon_side_asn" {
  description = "Private Autonomous System Number (ASN) for the Amazon side"
  type        = number
  default     = 64512
}

variable "vpn_gateway_az" {
  description = "Availability Zone for the VPN Gateway"
  type        = string
  default     = null
}

variable "customer_gateway_bgp_asn" {
  description = "BGP ASN of the customer gateway"
  type        = number
  default     = 65000
}

variable "customer_gateway_ip_address" {
  description = "IP address of the customer gateway's external interface"
  type        = string
}

variable "customer_gateway_device_name" {
  description = "Name for customer gateway device"
  type        = string
  default     = "on-premises-firewall"
}

variable "static_routes_only" {
  description = "Whether the VPN connection uses static routes"
  type        = bool
  default     = false
}

variable "enable_vpn_acceleration" {
  description = "Enable VPN acceleration"
  type        = bool
  default     = false
}

variable "local_ipv4_network_cidr" {
  description = "IPv4 CIDR on the customer gateway side"
  type        = string
  default     = "0.0.0.0/0"
}

variable "remote_ipv4_network_cidr" {
  description = "IPv4 CIDR on the AWS side"
  type        = string
  default     = "0.0.0.0/0"
}

variable "tunnel1_inside_cidr" {
  description = "CIDR block for tunnel 1 inside addresses"
  type        = string
  default     = "169.254.10.0/30"
}

variable "tunnel1_preshared_key" {
  description = "Preshared key for tunnel 1"
  type        = string
  default     = null
  sensitive   = true
}

variable "tunnel2_inside_cidr" {
  description = "CIDR block for tunnel 2 inside addresses"
  type        = string
  default     = "169.254.11.0/30"
}

variable "tunnel2_preshared_key" {
  description = "Preshared key for tunnel 2"
  type        = string
  default     = null
  sensitive   = true
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

variable "database_route_table_ids" {
  description = "List of database route table IDs for VPN route propagation"
  type        = list(string)
  default     = []
}

variable "intra_route_table_ids" {
  description = "List of intra route table IDs for VPN route propagation"
  type        = list(string)
  default     = []
}

variable "tags_common" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "prod"
    Example     = "complete"
  }
}

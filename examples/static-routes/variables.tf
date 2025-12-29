variable "account_name" {
  description = "Account name for resource naming"
  type        = string
  default     = "prod"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "static-vpn"
}

variable "vpc_id" {
  description = "VPC ID where VPN Gateway will be attached"
  type        = string
}

variable "customer_gateway_ip_address" {
  description = "IP address of the customer gateway's external interface"
  type        = string
}

variable "static_routes_destinations" {
  description = "List of CIDR blocks for static routes"
  type        = list(string)
  default     = ["192.168.1.0/24", "192.168.2.0/24"]
}

variable "private_route_table_ids" {
  description = "List of private route table IDs for VPN route propagation"
  type        = list(string)
  default     = []
}

variable "database_route_table_ids" {
  description = "List of database route table IDs for VPN route propagation"
  type        = list(string)
  default     = []
}

variable "tags_common" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "prod"
    Example     = "static-routes"
  }
}

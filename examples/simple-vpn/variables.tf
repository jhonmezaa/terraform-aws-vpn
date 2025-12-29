variable "account_name" {
  description = "Account name for resource naming"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "simple-vpn"
}

variable "vpc_id" {
  description = "VPC ID where VPN Gateway will be attached"
  type        = string
}

variable "customer_gateway_ip_address" {
  description = "IP address of the customer gateway's external interface"
  type        = string
}

variable "private_route_table_ids" {
  description = "List of private route table IDs for VPN route propagation"
  type        = list(string)
  default     = []
}

variable "tags_common" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "dev"
    Example     = "simple-vpn"
  }
}

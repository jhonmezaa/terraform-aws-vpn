variable "account_name" {
  description = "Account name for resource naming"
  type        = string
  default     = "prod"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "tgw-vpn"
}

variable "vpc_id" {
  description = "VPC ID where Transit Gateway will be attached"
  type        = string
}

variable "transit_gateway_id" {
  description = "ID of the Transit Gateway"
  type        = string
}

variable "transit_gateway_subnet_ids" {
  description = "Subnet IDs for Transit Gateway VPC attachment"
  type        = list(string)
}

variable "customer_gateway_ip_address" {
  description = "IP address of the customer gateway's external interface"
  type        = string
}

variable "tags_common" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "prod"
    Example     = "transit-gateway"
  }
}

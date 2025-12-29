# Simple VPN Example

This example demonstrates a basic Site-to-Site VPN connection with BGP dynamic routing.

## Features

- VPN Gateway attached to VPC
- Customer Gateway
- VPN Connection with BGP (dynamic routing)
- Route propagation to private route tables
- Default tunnel configuration

## Usage

```bash
# Initialize
terraform init

# Plan
terraform plan

# Apply
terraform apply
```

## Prerequisites

- Existing VPC with private subnets
- Customer gateway public IP address
- Private route table IDs

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| vpc_id | VPC ID where VPN Gateway will be attached | string | yes |
| customer_gateway_ip_address | IP address of the customer gateway's external interface | string | yes |
| private_route_table_ids | List of private route table IDs for VPN route propagation | list(string) | no |

## Outputs

| Name | Description |
|------|-------------|
| vpn_gateway_id | ID of the VPN Gateway |
| customer_gateway_id | ID of the Customer Gateway |
| vpn_connection_id | ID of the VPN Connection |
| vpn_connection_tunnel1_address | Public IP address of tunnel 1 |
| vpn_connection_tunnel2_address | Public IP address of tunnel 2 |

## Example terraform.tfvars

```hcl
account_name                = "dev"
project_name                = "simple-vpn"
vpc_id                      = "vpc-1234567890abcdef0"
customer_gateway_ip_address = "203.0.113.1"
private_route_table_ids     = ["rtb-1234567890abcdef0"]

tags_common = {
  Environment = "dev"
  Example     = "simple-vpn"
}
```

## Estimated Monthly Cost

- VPN Connection: ~$36/month per connection
- Data transfer: Variable based on usage

## Clean Up

```bash
terraform destroy
```

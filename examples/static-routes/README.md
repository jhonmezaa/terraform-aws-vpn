# Static Routes VPN Example

This example demonstrates a Site-to-Site VPN connection using static routing instead of BGP.

## Features

- VPN Gateway attached to VPC
- Customer Gateway
- VPN Connection with static routing
- Multiple static route destinations
- Route propagation to private and database route tables

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

- Existing VPC with private and database subnets
- Customer gateway public IP address
- Private and database route table IDs

## When to Use Static Routes

Use static routing when:
- Customer gateway device doesn't support BGP
- Simple, predictable routing is required
- You want explicit control over routes
- On-premises network has static IP ranges

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| vpc_id | VPC ID where VPN Gateway will be attached | string | yes |
| customer_gateway_ip_address | IP address of the customer gateway's external interface | string | yes |
| static_routes_destinations | List of CIDR blocks for static routes | list(string) | no |
| private_route_table_ids | List of private route table IDs | list(string) | no |
| database_route_table_ids | List of database route table IDs | list(string) | no |

## Outputs

| Name | Description |
|------|-------------|
| vpn_gateway_id | ID of the VPN Gateway |
| vpn_connection_id | ID of the VPN Connection |
| vpn_connection_routes | Static routes configured for the VPN connection |

## Example terraform.tfvars

```hcl
account_name                = "prod"
project_name                = "static-vpn"
vpc_id                      = "vpc-1234567890abcdef0"
customer_gateway_ip_address = "203.0.113.1"

static_routes_destinations = [
  "192.168.1.0/24",  # On-premises office network
  "192.168.2.0/24",  # On-premises data center
  "10.10.0.0/16"     # Additional internal network
]

private_route_table_ids  = ["rtb-1234567890abcdef0"]
database_route_table_ids = ["rtb-0987654321fedcba0"]

tags_common = {
  Environment = "prod"
  Example     = "static-routes"
}
```

## Estimated Monthly Cost

- VPN Connection: ~$36/month per connection
- Data transfer: Variable based on usage

## Clean Up

```bash
terraform destroy
```

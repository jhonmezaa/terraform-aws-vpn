# Transit Gateway VPN Example

This example demonstrates a Site-to-Site VPN connection using AWS Transit Gateway instead of a traditional VPN Gateway.

## Features

- VPN Connection attached to Transit Gateway
- Transit Gateway VPC attachment
- Customer Gateway
- BGP dynamic routing
- Multi-VPC connectivity through Transit Gateway

## Use Case

Transit Gateway VPN is ideal when:
- Connecting multiple VPCs to on-premises network through a single VPN
- Building a hub-and-spoke network architecture
- Centralized network management is required
- Scaling to many VPCs (Transit Gateway supports thousands of VPCs)

## Architecture

```
On-Premises Network
        |
   Customer Gateway
        |
    VPN Connection
        |
   Transit Gateway ──┬── VPC 1
                     ├── VPC 2
                     └── VPC 3
```

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

- Existing Transit Gateway
- VPC with subnets for Transit Gateway attachment
- Customer gateway public IP address

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| vpc_id | VPC ID for Transit Gateway attachment | string | yes |
| transit_gateway_id | ID of the Transit Gateway | string | yes |
| transit_gateway_subnet_ids | Subnet IDs for Transit Gateway VPC attachment | list(string) | yes |
| customer_gateway_ip_address | IP address of the customer gateway's external interface | string | yes |

## Outputs

| Name | Description |
|------|-------------|
| vpn_connection_id | ID of the VPN Connection |
| vpn_connection_transit_gateway_attachment_id | Transit Gateway attachment ID for VPN |
| transit_gateway_attachment_id | ID of the Transit Gateway VPC attachment |

## Example terraform.tfvars

```hcl
account_name                = "prod"
project_name                = "tgw-vpn"
vpc_id                      = "vpc-1234567890abcdef0"
transit_gateway_id          = "tgw-1234567890abcdef0"
customer_gateway_ip_address = "203.0.113.1"

transit_gateway_subnet_ids = [
  "subnet-1234567890abcdef0",
  "subnet-0987654321fedcba0"
]

tags_common = {
  Environment = "prod"
  Example     = "transit-gateway"
}
```

## Estimated Monthly Cost

- VPN Connection: ~$36/month per connection
- Transit Gateway: ~$36/month (base)
- Transit Gateway attachments: ~$36/month per VPC
- Data processing: $0.02 per GB
- Data transfer: Variable based on usage

## Benefits Over VPN Gateway

1. **Scalability**: Connect thousands of VPCs
2. **Centralization**: Single point for VPN management
3. **Routing**: Advanced routing capabilities
4. **Multi-region**: Support for inter-region peering

## Clean Up

```bash
terraform destroy
```

## Notes

- Transit Gateway must be in the same region as the VPC
- Ensure Transit Gateway route tables are configured correctly
- BGP ASN must not conflict with existing networks

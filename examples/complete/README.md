# Complete VPN Gateway Example

This example demonstrates all features of the VPN module with production-grade configuration.

## Features

- VPN Gateway with custom ASN
- Customer Gateway with device naming
- VPN Connection with BGP dynamic routing
- **Both tunnels fully configured** with:
  - Custom inside CIDR blocks
  - IKEv2 only
  - Strong encryption (AES256, AES256-GCM-16)
  - SHA2 integrity algorithms
  - DH groups 20-24 (2048-bit and higher)
  - CloudWatch Logs enabled
  - Dead Peer Detection with restart action
  - Custom rekey and replay window settings
- Route propagation to all route table types (private, public, database, intra)
- Custom tags for each resource type

## Security Configuration

This example uses production-grade security settings:

### Phase 1 (IKE)
- **Encryption**: AES256, AES256-GCM-16
- **Integrity**: SHA2-256, SHA2-384, SHA2-512
- **DH Groups**: 20, 21, 22, 23, 24 (2048-bit minimum)
- **Lifetime**: 28800 seconds (8 hours)
- **IKE Version**: IKEv2 only

### Phase 2 (IPsec)
- **Encryption**: AES256, AES256-GCM-16
- **Integrity**: SHA2-256, SHA2-384, SHA2-512
- **DH Groups**: 20, 21, 22, 23, 24 (Perfect Forward Secrecy)
- **Lifetime**: 3600 seconds (1 hour)

### Monitoring
- CloudWatch Logs enabled for both tunnels
- JSON output format for easier parsing
- 7-day retention period

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      AWS VPC                                │
│                                                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │   Private    │  │   Public     │  │   Database   │     │
│  │   Subnets    │  │   Subnets    │  │   Subnets    │     │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘     │
│         │                 │                  │             │
│         └────────┬────────┴──────────────────┘             │
│                  │                                         │
│           ┌──────▼──────┐                                  │
│           │ VPN Gateway │                                  │
│           └──────┬──────┘                                  │
└──────────────────┼─────────────────────────────────────────┘
                   │
                   │ Site-to-Site VPN Connection
                   │ (Dual Tunnels with BGP)
                   │
                   │
        ┌──────────▼──────────┐
        │  Customer Gateway   │
        │  (On-Premises)      │
        └─────────────────────┘
                   │
        ┌──────────▼──────────┐
        │  On-Premises        │
        │  Network            │
        └─────────────────────┘
```

## Usage

```bash
# Initialize
terraform init

# Plan
terraform plan

# Apply
terraform apply

# View sensitive outputs (preshared keys)
terraform output -json | jq
```

## Prerequisites

- Existing VPC with multiple subnet types
- Customer gateway public IP address
- Route table IDs for all subnet types

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| vpc_id | VPC ID where VPN Gateway will be attached | string | yes |
| customer_gateway_ip_address | IP address of the customer gateway | string | yes |
| amazon_side_asn | Amazon side BGP ASN | number | no |
| customer_gateway_bgp_asn | Customer side BGP ASN | number | no |
| tunnel1_inside_cidr | CIDR for tunnel 1 inside addresses | string | no |
| tunnel2_inside_cidr | CIDR for tunnel 2 inside addresses | string | no |
| tunnel1_preshared_key | Preshared key for tunnel 1 | string | no |
| tunnel2_preshared_key | Preshared key for tunnel 2 | string | no |
| private_route_table_ids | Private route table IDs | list(string) | no |
| public_route_table_ids | Public route table IDs | list(string) | no |
| database_route_table_ids | Database route table IDs | list(string) | no |
| intra_route_table_ids | Intra route table IDs | list(string) | no |

## Outputs

This example outputs all available information:
- VPN Gateway details (ID, ARN, ASN)
- Customer Gateway details
- VPN Connection details
- Both tunnel configurations (addresses, BGP settings)
- Preshared keys (sensitive)
- Route propagation status
- CloudWatch Log Group details

## Example terraform.tfvars

```hcl
account_name                = "prod"
project_name                = "complete-vpn"
vpc_id                      = "vpc-1234567890abcdef0"
customer_gateway_ip_address = "203.0.113.1"
customer_gateway_device_name = "cisco-asa-5516"

# BGP Configuration
amazon_side_asn          = 64512
customer_gateway_bgp_asn = 65000

# Tunnel Inside CIDRs (169.254.0.0/16 range for link-local)
tunnel1_inside_cidr = "169.254.10.0/30"
tunnel2_inside_cidr = "169.254.11.0/30"

# Optional: Custom preshared keys (will be auto-generated if not provided)
# tunnel1_preshared_key = "your-secure-key-here"
# tunnel2_preshared_key = "your-secure-key-here"

# Route Tables
private_route_table_ids = [
  "rtb-1111111111111111",
  "rtb-2222222222222222"
]

public_route_table_ids = [
  "rtb-3333333333333333"
]

database_route_table_ids = [
  "rtb-4444444444444444",
  "rtb-5555555555555555"
]

intra_route_table_ids = [
  "rtb-6666666666666666"
]

# Tags
tags_common = {
  Environment = "prod"
  Example     = "complete"
  Team        = "networking"
  CostCenter  = "infrastructure"
}
```

## Monitoring

Access CloudWatch Logs to monitor tunnel status:

```bash
# View tunnel 1 logs
aws logs tail /aws/vpn/tunnel1-prod-complete-vpn --follow

# View tunnel 2 logs
aws logs tail /aws/vpn/tunnel2-prod-complete-vpn --follow
```

## High Availability

This configuration provides HA through:
1. **Dual Tunnels**: Two independent IPsec tunnels
2. **BGP Routing**: Automatic failover between tunnels
3. **DPD with Restart**: Dead Peer Detection automatically restarts failed tunnels
4. **CloudWatch Monitoring**: Real-time visibility into tunnel health

## Estimated Monthly Cost

- VPN Connection: ~$36/month
- CloudWatch Logs: ~$0.50/month (assuming moderate logging)
- Data transfer: Variable based on usage

## Security Best Practices

1. **Use custom preshared keys**: Generate strong, unique keys for each tunnel
2. **Enable CloudWatch Logs**: Monitor for security events
3. **Use IKEv2**: More secure and efficient than IKEv1
4. **Strong encryption**: AES256-GCM provides both encryption and authentication
5. **High DH groups**: Groups 20+ provide strong key exchange security
6. **Rotate keys periodically**: Use the rekey settings to automate rotation

## Troubleshooting

### Tunnel not coming up
1. Check CloudWatch Logs for errors
2. Verify customer gateway IP is correct
3. Ensure BGP ASNs don't conflict
4. Verify firewall allows UDP 500, 4500 and ESP (protocol 50)

### BGP not establishing
1. Verify both ASNs are configured correctly
2. Check inside CIDR blocks don't overlap
3. Ensure customer gateway supports BGP

## Clean Up

```bash
terraform destroy
```

## References

- [AWS VPN Documentation](https://docs.aws.amazon.com/vpn/)
- [Site-to-Site VPN Tunnel Options](https://docs.aws.amazon.com/vpn/latest/s2svpn/VPNTunnels.html)
- [VPN CloudWatch Logs](https://docs.aws.amazon.com/vpn/latest/s2svpn/monitoring-cloudwatch-vpn.html)

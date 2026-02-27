# AWS VPN Gateway Terraform Module

Production-ready Terraform module for AWS Site-to-Site VPN with support for VPN Gateway, Customer Gateway, Transit Gateway integration, static/dynamic routing, and comprehensive tunnel configuration.

## Features

- **VPN Gateway**: Create or attach existing VPN Gateway to VPC
- **Customer Gateway**: Configure customer gateway with BGP ASN
- **VPN Connection**: Site-to-Site VPN with dual tunnels
- **Transit Gateway**: Optional Transit Gateway integration for multi-VPC connectivity
- **Routing**:
  - Static routes support
  - BGP dynamic routing
  - Route propagation to multiple route table types
- **Tunnel Configuration**: Full control over both IPsec tunnels
  - Phase 1 & 2 IKE parameters
  - Custom inside CIDR blocks
  - Preshared keys
  - Dead Peer Detection (DPD)
  - CloudWatch Logs integration
  - IKE version selection (v1/v2)
  - Rekey and replay window settings
- **High Availability**: Dual tunnel support with automatic failover
- **Monitoring**: CloudWatch Logs for tunnel events
- **VPN Acceleration**: Optional accelerated VPN endpoints

## Version

**Current Version**: 1.0.0
**Terraform**: >= 1.3
**AWS Provider**: >= 5.42

## Usage

### Basic VPN with BGP

```hcl
module "vpn" {
  source = "../../terraform-aws-vpn/vpn"

  # General
  account_name = "prod"
  project_name = "myapp"

  # VPN Gateway
  create_vpn_gateway = true
  vpc_id             = "vpc-1234567890abcdef0"
  amazon_side_asn    = 64512

  # Customer Gateway
  customer_gateway_bgp_asn   = 65000
  customer_gateway_ip_address = "203.0.113.1"

  # VPN Connection - BGP dynamic routing
  static_routes_only = false

  # Route Propagation
  propagate_private_route_tables_vgw = true
  private_route_table_ids            = ["rtb-1234567890abcdef0"]

  tags_common = {
    Environment = "prod"
  }
}
```

### Static Routes

```hcl
module "vpn" {
  source = "../../terraform-aws-vpn/vpn"

  account_name = "prod"
  project_name = "myapp"

  # VPN Gateway
  create_vpn_gateway = true
  vpc_id             = "vpc-1234567890abcdef0"

  # Customer Gateway
  customer_gateway_bgp_asn   = 65000
  customer_gateway_ip_address = "203.0.113.1"

  # Static routing
  static_routes_only         = true
  static_routes_destinations = [
    "192.168.1.0/24",
    "192.168.2.0/24"
  ]

  # Route Propagation
  propagate_private_route_tables_vgw = true
  private_route_table_ids            = ["rtb-1234567890abcdef0"]

  tags_common = {
    Environment = "prod"
  }
}
```

### Transit Gateway VPN

```hcl
module "vpn" {
  source = "../../terraform-aws-vpn/vpn"

  account_name = "prod"
  project_name = "myapp"

  # VPN Gateway not needed with Transit Gateway
  create_vpn_gateway = true
  vpc_id             = "vpc-1234567890abcdef0"

  # Customer Gateway
  customer_gateway_bgp_asn   = 65000
  customer_gateway_ip_address = "203.0.113.1"

  # Transit Gateway
  transit_gateway_id         = "tgw-1234567890abcdef0"
  transit_gateway_subnet_ids = [
    "subnet-1234567890abcdef0",
    "subnet-0987654321fedcba0"
  ]

  # BGP routing
  static_routes_only = false

  tags_common = {
    Environment = "prod"
  }
}
```

### Complete Configuration with All Features

```hcl
module "vpn" {
  source = "../../terraform-aws-vpn/vpn"

  # General
  account_name = "prod"
  project_name = "myapp"

  # VPN Gateway
  create_vpn_gateway = true
  vpc_id             = "vpc-1234567890abcdef0"
  amazon_side_asn    = 64512
  vpn_gateway_az     = "us-east-1a"

  # Customer Gateway
  customer_gateway_bgp_asn     = 65000
  customer_gateway_ip_address  = "203.0.113.1"
  customer_gateway_device_name = "cisco-asa-5516"

  # VPN Connection
  static_routes_only      = false
  enable_vpn_acceleration = false

  # Tunnel 1 - Custom configuration
  tunnel1_inside_cidr               = "169.254.10.0/30"
  tunnel1_preshared_key             = var.tunnel1_psk  # sensitive
  tunnel1_ike_versions              = ["ikev2"]
  tunnel1_dpd_timeout_action        = "restart"
  tunnel1_startup_action            = "start"

  # Tunnel 1 Phase 1 - Strong encryption
  tunnel1_phase1_dh_group_numbers      = [20, 21, 22, 23, 24]
  tunnel1_phase1_encryption_algorithms = ["AES256", "AES256-GCM-16"]
  tunnel1_phase1_integrity_algorithms  = ["SHA2-256", "SHA2-384", "SHA2-512"]
  tunnel1_phase1_lifetime_seconds      = 28800

  # Tunnel 1 Phase 2
  tunnel1_phase2_dh_group_numbers      = [20, 21, 22, 23, 24]
  tunnel1_phase2_encryption_algorithms = ["AES256", "AES256-GCM-16"]
  tunnel1_phase2_integrity_algorithms  = ["SHA2-256", "SHA2-384", "SHA2-512"]
  tunnel1_phase2_lifetime_seconds      = 3600

  # Tunnel 1 Monitoring
  tunnel1_cloudwatch_log_enabled       = true
  tunnel1_cloudwatch_log_group_arn     = aws_cloudwatch_log_group.tunnel1.arn
  tunnel1_cloudwatch_log_output_format = "json"

  # Tunnel 2 - Same configuration as Tunnel 1
  tunnel2_inside_cidr               = "169.254.11.0/30"
  tunnel2_preshared_key             = var.tunnel2_psk  # sensitive
  tunnel2_ike_versions              = ["ikev2"]
  tunnel2_dpd_timeout_action        = "restart"
  tunnel2_startup_action            = "start"
  tunnel2_phase1_dh_group_numbers      = [20, 21, 22, 23, 24]
  tunnel2_phase1_encryption_algorithms = ["AES256", "AES256-GCM-16"]
  tunnel2_phase1_integrity_algorithms  = ["SHA2-256", "SHA2-384", "SHA2-512"]
  tunnel2_phase1_lifetime_seconds      = 28800
  tunnel2_phase2_dh_group_numbers      = [20, 21, 22, 23, 24]
  tunnel2_phase2_encryption_algorithms = ["AES256", "AES256-GCM-16"]
  tunnel2_phase2_integrity_algorithms  = ["SHA2-256", "SHA2-384", "SHA2-512"]
  tunnel2_phase2_lifetime_seconds      = 3600
  tunnel2_cloudwatch_log_enabled       = true
  tunnel2_cloudwatch_log_group_arn     = aws_cloudwatch_log_group.tunnel2.arn
  tunnel2_cloudwatch_log_output_format = "json"

  # Route Propagation
  propagate_private_route_tables_vgw  = true
  propagate_database_route_tables_vgw = true
  private_route_table_ids             = ["rtb-1111111111111111"]
  database_route_table_ids            = ["rtb-2222222222222222"]

  tags_common = {
    Environment = "prod"
    Team        = "networking"
  }
}
```

## Examples

| Example | Description |
|---------|-------------|
| [simple-vpn](./examples/simple-vpn) | Basic VPN with BGP dynamic routing |
| [static-routes](./examples/static-routes) | VPN with static routing |
| [transit-gateway](./examples/transit-gateway) | VPN via Transit Gateway |
| [complete](./examples/complete) | All features with production-grade security |

## Architecture

### Standard VPN Gateway

```
┌─────────────────────────────────────┐
│              AWS VPC                │
│                                     │
│  ┌──────────┐    ┌──────────┐     │
│  │ Private  │    │  Public  │     │
│  │ Subnets  │    │ Subnets  │     │
│  └────┬─────┘    └────┬─────┘     │
│       │               │            │
│  ┌────▼───────────────▼─────┐     │
│  │    Route Tables           │     │
│  │  (VPN Route Propagation)  │     │
│  └────┬──────────────────────┘     │
│       │                            │
│  ┌────▼──────┐                     │
│  │    VPN    │                     │
│  │  Gateway  │                     │
│  └────┬──────┘                     │
└───────┼────────────────────────────┘
        │
        │ Site-to-Site VPN
        │ (Dual Tunnels)
        │
   ┌────▼────────┐
   │  Customer   │
   │   Gateway   │
   └─────────────┘
        │
   ┌────▼────────┐
   │On-Premises  │
   │   Network   │
   └─────────────┘
```

### Transit Gateway VPN

```
┌──────────┐  ┌──────────┐  ┌──────────┐
│  VPC 1   │  │  VPC 2   │  │  VPC 3   │
└────┬─────┘  └────┬─────┘  └────┬─────┘
     │             │              │
     └──────┬──────┴──────┬───────┘
            │             │
       ┌────▼─────────────▼────┐
       │   Transit Gateway     │
       └────┬──────────────────┘
            │
            │ VPN Connection
            │
       ┌────▼─────────┐
       │   Customer   │
       │   Gateway    │
       └──────────────┘
            │
       ┌────▼─────────┐
       │ On-Premises  │
       │   Network    │
       └──────────────┘
```

## Naming Convention

Resources follow the pattern: `{region_prefix}-{resource}-{account_name}-{project_name}`

Examples:
- VPN Gateway: `ause1-vgw-prod-myapp`
- Customer Gateway: `ause1-cgw-prod-myapp`
- VPN Connection: `ause1-vpn-prod-myapp`

Region prefixes are auto-detected or can be overridden via `region_prefix` variable.

Set `use_region_prefix = false` to omit the region prefix from all resource names (e.g., `vgw-prod-myapp` instead of `ause1-vgw-prod-myapp`).

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.3 |
| aws | >= 5.42 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 5.42 |

## Resources Created

- `aws_vpn_gateway` (optional)
- `aws_vpn_gateway_attachment` (optional)
- `aws_customer_gateway` (optional)
- `aws_vpn_connection`
- `aws_vpn_connection_route` (for static routes)
- `aws_vpn_gateway_route_propagation` (multiple)
- `aws_ec2_transit_gateway_vpc_attachment` (optional)

## Authors

Module managed by [Jhon Meza](https://github.com/jmeza)

## License

MIT Licensed. See [LICENSE](./LICENSE) for full details.

## Changelog

See [CHANGELOG.md](./CHANGELOG.md) for release history.
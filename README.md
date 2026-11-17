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

**Current Version**: 1.4.0
**Terraform**: >= 1.0
**AWS Provider**: >= 6.0

## Usage

### Basic VPN with BGP

```hcl
module "vpn" {
  source = "github.com/jhonmezaa/terraform-aws-vpn//vpn?ref=v1.4.0"

  # General
  account_name = "prod"
  project_name = "myapp"

  # VPN Gateway
  create_vpn_gateway = true
  vpc_id             = "vpc-1234567890abcdef0"
  amazon_side_asn    = 64512

  # Customer Gateway
  customer_gateway_bgp_asn    = 65000
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
  source = "github.com/jhonmezaa/terraform-aws-vpn//vpn?ref=v1.4.0"

  account_name = "prod"
  project_name = "myapp"

  # VPN Gateway
  create_vpn_gateway = true
  vpc_id             = "vpc-1234567890abcdef0"

  # Customer Gateway
  customer_gateway_bgp_asn    = 65000
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
  source = "github.com/jhonmezaa/terraform-aws-vpn//vpn?ref=v1.4.0"

  account_name = "prod"
  project_name = "myapp"

  # Master switch; no VPN Gateway is created in Transit Gateway mode.
  # vpc_id is used for the Transit Gateway VPC attachment.
  create_vpn_gateway = true
  vpc_id             = "vpc-1234567890abcdef0"

  # Customer Gateway
  customer_gateway_bgp_asn    = 65000
  customer_gateway_ip_address = "203.0.113.1"

  # Transit Gateway
  use_existing_transit_gateway = true
  transit_gateway_id           = "tgw-1234567890abcdef0"
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
  source = "github.com/jhonmezaa/terraform-aws-vpn//vpn?ref=v1.4.0"

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

| Example                                       | Description                                 |
| --------------------------------------------- | ------------------------------------------- |
| [simple-vpn](./examples/simple-vpn)           | Basic VPN with BGP dynamic routing          |
| [static-routes](./examples/static-routes)     | VPN with static routing                     |
| [transit-gateway](./examples/transit-gateway) | VPN via Transit Gateway                     |
| [complete](./examples/complete)               | All features with production-grade security |

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

Region prefixes are auto-detected from the provider region with the shared region map (`us-east-1` => `ause1`, `eu-west-1` => `euwe1`, ...; unknown regions fall back to `aws`) or can be overridden via the `region_prefix` variable. The names are applied as the `Name` tag (these AWS resources have no name argument).

In Transit Gateway mode (`use_existing_transit_gateway = true`) the attachment that AWS creates for the VPN connection is tagged too (`tgw-attach-vpn-{account_name}-{project_name}`), unless `tag_vpn_transit_gateway_attachment = false`.

Set `use_region_prefix = false` to omit the region prefix from all resource names (e.g., `vgw-prod-myapp` instead of `ause1-vgw-prod-myapp`).

## Requirements

| Name      | Version |
| --------- | ------- |
| terraform | >= 1.0  |
| aws       | >= 6.0  |

## Providers

| Name | Version |
| ---- | ------- |
| aws  | >= 6.0  |

## Resources Created

- `aws_vpn_gateway` (optional)
- `aws_vpn_gateway_attachment` (optional)
- `aws_customer_gateway` (optional)
- `aws_vpn_connection`
- `aws_vpn_connection_route` (for static routes)
- `aws_vpn_gateway_route_propagation` (multiple)
- `aws_ec2_transit_gateway_vpc_attachment` (optional)
- `aws_ec2_transit_gateway_route_table_association` / `aws_ec2_transit_gateway_route_table_propagation` (optional, custom TGW route tables)
- `aws_ec2_tag` (Transit Gateway mode: tags for the VPN Transit Gateway attachment)

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| `account_name` | Account name for resource naming (e.g., 'prod', 'dev', 'staging') | `string` | n/a | yes |
| `project_name` | Project name for resource naming | `string` | n/a | yes |
| `region_prefix` | Region prefix override (auto-detected if not provided) | `string` | `null` | no |
| `use_region_prefix` | Whether to include the region prefix in resource names. When false, names omit the region prefix. | `bool` | `true` | no |
| `tags_common` | Common tags to apply to all resources | `map(string)` | `{}` | no |
| `create_vpn_gateway` | Master switch: create the VPN resources (VPN Gateway, Customer Gateway, VPN connection, Transit Gateway attachment). The VPN Gateway itself is skipped when use_existing_transit_gateway = true or use_existing_vpn_gateway = true | `bool` | `true` | no |
| `vpc_id` | VPC ID where VPN Gateway will be attached | `string` | `null` | no |
| `vpn_gateway_id` | ID of existing VPN Gateway to attach to VPC (used when use_existing_vpn_gateway = true) | `string` | `null` | no |
| `use_existing_vpn_gateway` | Set to true when providing an existing VPN Gateway ID via vpn_gateway_id. This avoids plan-time errors when the ID comes from another module output. | `bool` | `false` | no |
| `amazon_side_asn` | Private Autonomous System Number (ASN) for the Amazon side of a BGP session | `number` | `64512` | no |
| `vpn_gateway_az` | Availability Zone for the VPN Gateway (optional) | `string` | `null` | no |
| `vpn_gateway_tags` | Additional tags for VPN Gateway | `map(string)` | `{}` | no |
| `customer_gateway_id` | ID of existing Customer Gateway (used when use_existing_customer_gateway = true) | `string` | `null` | no |
| `use_existing_customer_gateway` | Set to true when providing an existing Customer Gateway ID via customer_gateway_id. This avoids plan-time errors when the ID comes from another module output. | `bool` | `false` | no |
| `customer_gateway_bgp_asn` | BGP ASN of the customer gateway | `number` | `null` | no |
| `customer_gateway_ip_address` | IP address of the customer gateway's external interface | `string` | `null` | no |
| `customer_gateway_certificate_arn` | ARN for customer gateway certificate | `string` | `null` | no |
| `customer_gateway_device_name` | Name for customer gateway device | `string` | `null` | no |
| `customer_gateway_tags` | Additional tags for Customer Gateway | `map(string)` | `{}` | no |
| `static_routes_only` | Whether the VPN connection uses static routes (true) or BGP dynamic routing (false) | `bool` | `false` | no |
| `static_routes_destinations` | List of CIDR blocks for static routes (only used if static_routes_only is true) | `list(string)` | `null` | no |
| `enable_vpn_acceleration` | Enable VPN acceleration | `bool` | `false` | no |
| `local_ipv4_network_cidr` | IPv4 CIDR on the customer gateway (on-premises) side of the VPN connection | `string` | `"0.0.0.0/0"` | no |
| `remote_ipv4_network_cidr` | IPv4 CIDR on the AWS side of the VPN connection | `string` | `"0.0.0.0/0"` | no |
| `local_ipv6_network_cidr` | IPv6 CIDR on the customer gateway (on-premises) side of the VPN connection | `string` | `null` | no |
| `remote_ipv6_network_cidr` | IPv6 CIDR on the AWS side of the VPN connection | `string` | `null` | no |
| `outside_ip_address_type` | Indicates if a Public S2S VPN or Private S2S VPN over AWS Direct Connect. Valid values are 'PrivateIpv4' or 'PublicIpv4' | `string` | `"PublicIpv4"` | no |
| `transport_transit_gateway_attachment_id` | The attachment ID of the Transit Gateway attachment to Direct Connect Gateway | `string` | `null` | no |
| `tunnel_inside_ip_version` | Indicate whether the VPN tunnels process IPv4 or IPv6 traffic. Valid values are ipv4 or ipv6 | `string` | `"ipv4"` | no |
| `vpn_connection_tags` | Additional tags for VPN Connection | `map(string)` | `{}` | no |
| `tunnel1_inside_cidr` | CIDR block for tunnel 1 inside addresses | `string` | `null` | no |
| `tunnel1_inside_ipv6_cidr` | IPv6 CIDR block for tunnel 1 inside addresses | `string` | `null` | no |
| `tunnel1_preshared_key` | Preshared key for tunnel 1 (will be generated if not provided). 8-64 characters (letters, numbers, periods and underscores) and cannot start with zero | `string` | `null` | no |
| `tunnel1_dpd_timeout_action` | Action to take after DPD timeout occurs for tunnel 1. Valid values are 'clear', 'none', or 'restart' | `string` | `"clear"` | no |
| `tunnel1_dpd_timeout_seconds` | The number of seconds after which a DPD timeout occurs for tunnel 1 | `number` | `30` | no |
| `tunnel1_enable_tunnel_lifecycle_control` | Turn on or off tunnel endpoint lifecycle control for tunnel 1 | `bool` | `false` | no |
| `tunnel1_ike_versions` | IKE versions permitted for tunnel 1. Valid values are 'ikev1' or 'ikev2' | `list(string)` | `["ikev1", "ikev2"]` | no |
| `tunnel1_startup_action` | The action to take when the establishing the tunnel for tunnel 1. Valid values are 'add' or 'start' | `string` | `"add"` | no |
| `tunnel1_rekey_fuzz_percentage` | Percentage of rekey window for tunnel 1, during which rekey time is randomly selected | `number` | `100` | no |
| `tunnel1_rekey_margin_time_seconds` | Margin time before rekey process starts for tunnel 1 | `number` | `540` | no |
| `tunnel1_replay_window_size` | Number of packets in an IKE replay window for tunnel 1 | `number` | `1024` | no |
| `tunnel1_phase1_dh_group_numbers` | List of Diffie-Hellman group numbers permitted for tunnel 1 phase 1 IKE negotiations | `list(number)` | `[2, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24]` | no |
| `tunnel1_phase1_encryption_algorithms` | List of encryption algorithms permitted for tunnel 1 phase 1 IKE negotiations | `list(string)` | `["AES128", "AES256", "AES128-GCM-16", "AES256-GCM-16"]` | no |
| `tunnel1_phase1_integrity_algorithms` | List of integrity algorithms permitted for tunnel 1 phase 1 IKE negotiations | `list(string)` | `["SHA1", "SHA2-256", "SHA2-384", "SHA2-512"]` | no |
| `tunnel1_phase1_lifetime_seconds` | Lifetime for tunnel 1 phase 1 IKE negotiations, in seconds | `number` | `28800` | no |
| `tunnel1_phase2_dh_group_numbers` | List of Diffie-Hellman group numbers permitted for tunnel 1 phase 2 IKE negotiations | `list(number)` | `[2, 5, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24]` | no |
| `tunnel1_phase2_encryption_algorithms` | List of encryption algorithms permitted for tunnel 1 phase 2 IKE negotiations | `list(string)` | `["AES128", "AES256", "AES128-GCM-16", "AES256-GCM-16"]` | no |
| `tunnel1_phase2_integrity_algorithms` | List of integrity algorithms permitted for tunnel 1 phase 2 IKE negotiations | `list(string)` | `["SHA1", "SHA2-256", "SHA2-384", "SHA2-512"]` | no |
| `tunnel1_phase2_lifetime_seconds` | Lifetime for tunnel 1 phase 2 IKE negotiations, in seconds | `number` | `3600` | no |
| `tunnel1_cloudwatch_log_enabled` | Enable CloudWatch logs for tunnel 1 | `bool` | `false` | no |
| `tunnel1_cloudwatch_log_group_arn` | CloudWatch log group ARN for tunnel 1 | `string` | `null` | no |
| `tunnel1_cloudwatch_log_output_format` | CloudWatch log output format for tunnel 1. Valid values are 'json' or 'text' | `string` | `"json"` | no |
| `tunnel2_inside_cidr` | CIDR block for tunnel 2 inside addresses | `string` | `null` | no |
| `tunnel2_inside_ipv6_cidr` | IPv6 CIDR block for tunnel 2 inside addresses | `string` | `null` | no |
| `tunnel2_preshared_key` | Preshared key for tunnel 2 (will be generated if not provided). 8-64 characters (letters, numbers, periods and underscores) and cannot start with zero | `string` | `null` | no |
| `tunnel2_dpd_timeout_action` | Action to take after DPD timeout occurs for tunnel 2. Valid values are 'clear', 'none', or 'restart' | `string` | `"clear"` | no |
| `tunnel2_dpd_timeout_seconds` | The number of seconds after which a DPD timeout occurs for tunnel 2 | `number` | `30` | no |
| `tunnel2_enable_tunnel_lifecycle_control` | Turn on or off tunnel endpoint lifecycle control for tunnel 2 | `bool` | `false` | no |
| `tunnel2_ike_versions` | IKE versions permitted for tunnel 2. Valid values are 'ikev1' or 'ikev2' | `list(string)` | `["ikev1", "ikev2"]` | no |
| `tunnel2_startup_action` | The action to take when the establishing the tunnel for tunnel 2. Valid values are 'add' or 'start' | `string` | `"add"` | no |
| `tunnel2_rekey_fuzz_percentage` | Percentage of rekey window for tunnel 2, during which rekey time is randomly selected | `number` | `100` | no |
| `tunnel2_rekey_margin_time_seconds` | Margin time before rekey process starts for tunnel 2 | `number` | `540` | no |
| `tunnel2_replay_window_size` | Number of packets in an IKE replay window for tunnel 2 | `number` | `1024` | no |
| `tunnel2_phase1_dh_group_numbers` | List of Diffie-Hellman group numbers permitted for tunnel 2 phase 1 IKE negotiations | `list(number)` | `[2, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24]` | no |
| `tunnel2_phase1_encryption_algorithms` | List of encryption algorithms permitted for tunnel 2 phase 1 IKE negotiations | `list(string)` | `["AES128", "AES256", "AES128-GCM-16", "AES256-GCM-16"]` | no |
| `tunnel2_phase1_integrity_algorithms` | List of integrity algorithms permitted for tunnel 2 phase 1 IKE negotiations | `list(string)` | `["SHA1", "SHA2-256", "SHA2-384", "SHA2-512"]` | no |
| `tunnel2_phase1_lifetime_seconds` | Lifetime for tunnel 2 phase 1 IKE negotiations, in seconds | `number` | `28800` | no |
| `tunnel2_phase2_dh_group_numbers` | List of Diffie-Hellman group numbers permitted for tunnel 2 phase 2 IKE negotiations | `list(number)` | `[2, 5, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24]` | no |
| `tunnel2_phase2_encryption_algorithms` | List of encryption algorithms permitted for tunnel 2 phase 2 IKE negotiations | `list(string)` | `["AES128", "AES256", "AES128-GCM-16", "AES256-GCM-16"]` | no |
| `tunnel2_phase2_integrity_algorithms` | List of integrity algorithms permitted for tunnel 2 phase 2 IKE negotiations | `list(string)` | `["SHA1", "SHA2-256", "SHA2-384", "SHA2-512"]` | no |
| `tunnel2_phase2_lifetime_seconds` | Lifetime for tunnel 2 phase 2 IKE negotiations, in seconds | `number` | `3600` | no |
| `tunnel2_cloudwatch_log_enabled` | Enable CloudWatch logs for tunnel 2 | `bool` | `false` | no |
| `tunnel2_cloudwatch_log_group_arn` | CloudWatch log group ARN for tunnel 2 | `string` | `null` | no |
| `tunnel2_cloudwatch_log_output_format` | CloudWatch log output format for tunnel 2. Valid values are 'json' or 'text' | `string` | `"json"` | no |
| `transit_gateway_id` | ID of the Transit Gateway to attach VPN to (used when use_existing_transit_gateway = true) | `string` | `null` | no |
| `use_existing_transit_gateway` | Set to true when providing an existing Transit Gateway ID via transit_gateway_id. This avoids plan-time errors when the ID comes from another module output. | `bool` | `false` | no |
| `transit_gateway_subnet_ids` | Subnet IDs for Transit Gateway VPC attachment | `list(string)` | `[]` | no |
| `transit_gateway_dns_support` | Whether DNS support is enabled for Transit Gateway VPC attachment | `string` | `"enable"` | no |
| `transit_gateway_ipv6_support` | Whether IPv6 support is enabled for Transit Gateway VPC attachment | `string` | `"disable"` | no |
| `transit_gateway_appliance_mode_support` | Whether appliance mode support is enabled for Transit Gateway VPC attachment | `string` | `"disable"` | no |
| `transit_gateway_default_route_table_association` | Whether the VPC attachment is associated with the default Transit Gateway route table | `bool` | `true` | no |
| `transit_gateway_default_route_table_propagation` | Whether the VPC attachment propagates routes to the default Transit Gateway route table | `bool` | `true` | no |
| `transit_gateway_route_table_association_ids` | List of Transit Gateway route table IDs to associate with VPC and VPN attachments. When specified, disables default route table association. | `list(string)` | `[]` | no |
| `transit_gateway_route_table_propagation_ids` | List of Transit Gateway route table IDs to propagate routes from VPC and VPN attachments. When specified, disables default route table propagation. | `list(string)` | `[]` | no |
| `transit_gateway_attachment_tags` | Additional tags for Transit Gateway VPC attachment | `map(string)` | `{}` | no |
| `tag_vpn_transit_gateway_attachment` | Whether to tag the Transit Gateway attachment that AWS creates for a TGW VPN connection (aws_ec2_tag). Only used when use_existing_transit_gateway = true | `bool` | `true` | no |
| `vpn_transit_gateway_attachment_tags` | Additional tags for the Transit Gateway attachment of the VPN connection | `map(string)` | `{}` | no |
| `propagate_private_route_tables_vgw` | Enable route propagation to private route tables | `bool` | `false` | no |
| `propagate_public_route_tables_vgw` | Enable route propagation to public route tables | `bool` | `false` | no |
| `propagate_intra_route_tables_vgw` | Enable route propagation to intra route tables | `bool` | `false` | no |
| `propagate_database_route_tables_vgw` | Enable route propagation to database route tables | `bool` | `false` | no |
| `private_route_table_ids` | List of private route table IDs for VPN route propagation | `list(string)` | `[]` | no |
| `public_route_table_ids` | List of public route table IDs for VPN route propagation | `list(string)` | `[]` | no |
| `intra_route_table_ids` | List of intra route table IDs for VPN route propagation | `list(string)` | `[]` | no |
| `database_route_table_ids` | List of database route table IDs for VPN route propagation | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| `vpn_gateway_id` | ID of the VPN Gateway |
| `vpn_gateway_arn` | ARN of the VPN Gateway |
| `vpn_gateway_amazon_side_asn` | The Autonomous System Number (ASN) for the Amazon side of the gateway |
| `customer_gateway_id` | ID of the Customer Gateway |
| `customer_gateway_arn` | ARN of the Customer Gateway |
| `customer_gateway_bgp_asn` | BGP ASN of the Customer Gateway |
| `customer_gateway_ip_address` | IP address of the Customer Gateway |
| `vpn_connection_id` | ID of the VPN Connection |
| `vpn_connection_arn` | ARN of the VPN Connection |
| `vpn_connection_customer_gateway_configuration` | The configuration information for the VPN connection's customer gateway (in the native XML format) (sensitive) |
| `vpn_connection_type` | The type of VPN connection |
| `vpn_connection_static_routes_only` | Whether the VPN connection uses static routes exclusively |
| `vpn_connection_enable_acceleration` | Indicate whether to enable acceleration for the VPN connection |
| `vpn_connection_transit_gateway_attachment_id` | When associated with a Transit Gateway, the attachment ID |
| `vpn_connection_core_network_arn` | The ARN of the core network |
| `vpn_connection_core_network_attachment_arn` | The ARN of the core network attachment |
| `vpn_connection_tunnel1_address` | The public IP address of the first VPN tunnel |
| `vpn_connection_tunnel1_cgw_inside_address` | The RFC 6890 link-local address of the first VPN tunnel (Customer Gateway Side) |
| `vpn_connection_tunnel1_vgw_inside_address` | The RFC 6890 link-local address of the first VPN tunnel (VPN Gateway Side) |
| `vpn_connection_tunnel1_preshared_key` | The preshared key of the first VPN tunnel (sensitive) |
| `vpn_connection_tunnel1_bgp_asn` | The bgp asn number of the first VPN tunnel |
| `vpn_connection_tunnel1_bgp_holdtime` | The bgp holdtime of the first VPN tunnel |
| `vpn_connection_tunnel2_address` | The public IP address of the second VPN tunnel |
| `vpn_connection_tunnel2_cgw_inside_address` | The RFC 6890 link-local address of the second VPN tunnel (Customer Gateway Side) |
| `vpn_connection_tunnel2_vgw_inside_address` | The RFC 6890 link-local address of the second VPN tunnel (VPN Gateway Side) |
| `vpn_connection_tunnel2_preshared_key` | The preshared key of the second VPN tunnel (sensitive) |
| `vpn_connection_tunnel2_bgp_asn` | The bgp asn number of the second VPN tunnel |
| `vpn_connection_tunnel2_bgp_holdtime` | The bgp holdtime of the second VPN tunnel |
| `vpn_connection_routes` | Static routes associated with the VPN connection |
| `transit_gateway_attachment_id` | ID of the Transit Gateway VPC attachment |
| `vpn_transit_gateway_attachment_tags` | Tags applied to the Transit Gateway attachment of the VPN connection (TGW mode only) |
| `transit_gateway_attachment_state` | Derived state of the Transit Gateway VPC attachment: "available" when the attachment is managed by this module, null otherwise (not read from the AWS API) |
| `vpn_gateway_route_propagation_private` | Private route table IDs with VPN route propagation enabled |
| `vpn_gateway_route_propagation_public` | Public route table IDs with VPN route propagation enabled |
| `vpn_gateway_route_propagation_intra` | Intra route table IDs with VPN route propagation enabled |
| `vpn_gateway_route_propagation_database` | Database route table IDs with VPN route propagation enabled |
| `tgw_route_table_vpc_associations` | Map of Transit Gateway route table associations for VPC attachment |
| `tgw_route_table_vpn_associations` | Map of Transit Gateway route table associations for VPN attachment |
| `tgw_route_table_vpc_propagations` | Map of Transit Gateway route table propagations for VPC attachment |
| `tgw_route_table_vpn_propagations` | Map of Transit Gateway route table propagations for VPN attachment |

## Authors

Module managed by [Jhon Meza](https://github.com/jhonmezaa)

## License

MIT Licensed. See [LICENSE](./LICENSE) for full details.

## Changelog

See [CHANGELOG.md](./CHANGELOG.md) for release history.

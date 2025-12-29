# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-12-29

### Added

#### Core Features
- VPN Gateway creation and attachment to VPC
- Customer Gateway configuration with BGP ASN
- Site-to-Site VPN Connection with dual tunnels
- Transit Gateway integration for multi-VPC connectivity
- Static routes support for VPN connections
- BGP dynamic routing support
- Route propagation to multiple route table types (private, public, database, intra)

#### Tunnel Configuration
- Full Phase 1 IKE configuration (DH groups, encryption, integrity, lifetime)
- Full Phase 2 IPsec configuration (DH groups, encryption, integrity, lifetime)
- Custom inside CIDR blocks for both tunnels
- Custom inside IPv6 CIDR blocks
- Preshared key configuration (auto-generated if not provided)
- Dead Peer Detection (DPD) with configurable timeout and action
- IKE version selection (IKEv1, IKEv2)
- Startup action configuration (add/start)
- Rekey fuzz percentage and margin time
- Replay window size configuration
- Tunnel lifecycle control

#### Monitoring & Logging
- CloudWatch Logs integration for both tunnels
- Configurable log output format (JSON/text)
- Log group ARN configuration

#### High Availability
- Dual tunnel support with automatic failover
- BGP for dynamic route advertisement
- DPD with automatic tunnel restart

#### Advanced Features
- VPN acceleration support
- IPv4 and IPv6 network CIDR configuration
- Outside IP address type selection (Public/Private)
- Transport Transit Gateway attachment support
- Transit Gateway DNS and IPv6 support
- Transit Gateway appliance mode support
- Transit Gateway default route table association and propagation

#### Resource Naming
- Consistent naming convention across all resources
- Region prefix auto-detection for 18+ AWS regions
- Override capability for region prefix
- Account and project name integration

#### Outputs
- Comprehensive VPN Gateway outputs (ID, ARN, ASN)
- Customer Gateway outputs (ID, ARN, BGP ASN, IP)
- VPN Connection outputs (ID, ARN, type, configuration)
- Tunnel 1 & 2 outputs (addresses, inside IPs, preshared keys, BGP settings)
- Static route outputs
- Transit Gateway attachment outputs
- Route propagation status for all route table types

#### Examples
- **simple-vpn**: Basic VPN with BGP dynamic routing
- **static-routes**: VPN with static routing configuration
- **transit-gateway**: Transit Gateway VPN integration
- **complete**: All features enabled with production-grade security settings

#### Documentation
- Comprehensive README with usage examples
- Architecture diagrams for standard and Transit Gateway VPN
- Security best practices documentation
- Cost estimation guide
- High availability configuration guide
- Troubleshooting section
- Individual README for each example

#### Validation
- Terraform >= 1.3 compatibility
- AWS Provider >= 5.42 compatibility
- Input variable validation for:
  - Amazon side ASN (64512-65534)
  - Customer Gateway BGP ASN (1-4294967295)
  - DPD timeout (minimum 30 seconds)
  - Phase 1 lifetime (900-28800 seconds)
  - Phase 2 lifetime (900-3600 seconds)
  - Rekey fuzz percentage (0-100)
  - Rekey margin time (60-1800 seconds)
  - Replay window size (64-2048)
  - Outside IP address type (PrivateIpv4/PublicIpv4)
  - Tunnel inside IP version (ipv4/ipv6)
  - Transit Gateway settings (enable/disable)

#### Security
- Sensitive output handling for preshared keys
- Sensitive variable handling for tunnel PSKs
- Production-grade encryption defaults
- Strong DH group support (groups 20-24)
- SHA2 integrity algorithm support
- AES256-GCM-16 encryption support

### Infrastructure
- MIT License
- Git repository initialization
- .gitignore for Terraform files
- Module structure following monorepo patterns
- Version constraints in all examples

[1.0.0]: https://github.com/jmeza/terraform-aws-vpn/releases/tag/v1.0.0

################################################################################
# Local Values
################################################################################

locals {
  # Region prefix mapping (consistent with other modules)
  region_prefix_map = {
    "us-east-1"      = "ause1"
    "us-east-2"      = "ause2"
    "us-west-1"      = "usw1"
    "us-west-2"      = "usw2"
    "eu-west-1"      = "euw1"
    "eu-west-2"      = "euw2"
    "eu-west-3"      = "euw3"
    "eu-central-1"   = "euc1"
    "eu-north-1"     = "eun1"
    "ap-southeast-1" = "apse1"
    "ap-southeast-2" = "apse2"
    "ap-northeast-1" = "apne1"
    "ap-northeast-2" = "apne2"
    "ap-south-1"     = "aps1"
    "sa-east-1"      = "sae1"
    "ca-central-1"   = "cac1"
    "af-south-1"     = "afs1"
    "me-south-1"     = "mes1"
  }

  region_prefix = var.region_prefix != null ? var.region_prefix : lookup(local.region_prefix_map, data.aws_region.current.id, "aws")

  # VPN Gateway
  create_vpn_gateway = var.create_vpn_gateway && var.vpn_gateway_id == null
  vpn_gateway_id = var.create_vpn_gateway ? (
    var.vpn_gateway_id != null ? var.vpn_gateway_id : try(aws_vpn_gateway.this[0].id, null)
  ) : null

  # Customer Gateway
  create_customer_gateway = var.create_vpn_gateway && var.customer_gateway_id == null && var.customer_gateway_bgp_asn != null && var.customer_gateway_ip_address != null
  customer_gateway_id     = var.customer_gateway_id != null ? var.customer_gateway_id : try(aws_customer_gateway.this[0].id, null)

  # VPN Connection
  create_vpn_connection = var.create_vpn_gateway && (local.create_customer_gateway || var.customer_gateway_id != null)

  # Transit Gateway
  create_transit_gateway_attachment = var.transit_gateway_id != null && var.create_vpn_gateway

  # Tags
  common_tags = merge(
    var.tags_common,
    {
      Module    = "terraform-aws-vpn"
      ManagedBy = "Terraform"
    }
  )

  vpn_gateway_tags = merge(
    local.common_tags,
    var.vpn_gateway_tags,
    {
      Name = "${local.region_prefix}-vgw-${var.account_name}-${var.project_name}"
    }
  )

  customer_gateway_tags = merge(
    local.common_tags,
    var.customer_gateway_tags,
    {
      Name = "${local.region_prefix}-cgw-${var.account_name}-${var.project_name}"
    }
  )

  vpn_connection_tags = merge(
    local.common_tags,
    var.vpn_connection_tags,
    {
      Name = "${local.region_prefix}-vpn-${var.account_name}-${var.project_name}"
    }
  )

  transit_gateway_attachment_tags = merge(
    local.common_tags,
    var.transit_gateway_attachment_tags,
    {
      Name = "${local.region_prefix}-tgw-attach-${var.account_name}-${var.project_name}"
    }
  )

  # Static routes
  vpn_gateway_routes = var.static_routes_only && var.static_routes_destinations != null ? toset(var.static_routes_destinations) : toset([])

  # Route table IDs for propagation
  private_route_table_ids  = var.propagate_private_route_tables_vgw ? toset(var.private_route_table_ids) : toset([])
  public_route_table_ids   = var.propagate_public_route_tables_vgw ? toset(var.public_route_table_ids) : toset([])
  intra_route_table_ids    = var.propagate_intra_route_tables_vgw ? toset(var.intra_route_table_ids) : toset([])
  database_route_table_ids = var.propagate_database_route_tables_vgw ? toset(var.database_route_table_ids) : toset([])
}

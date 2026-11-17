################################################################################
# Local Values
################################################################################

locals {
  # Region prefix mapping (canonical map shared by all jhonmezaa/terraform-aws-* modules)
  region_prefix_map = {
    # US Regions
    "us-east-1" = "ause1"
    "us-east-2" = "ause2"
    "us-west-1" = "ausw1"
    "us-west-2" = "ausw2"
    # EU Regions
    "eu-west-1"    = "euwe1"
    "eu-west-2"    = "euwe2"
    "eu-west-3"    = "euwe3"
    "eu-central-1" = "euce1"
    "eu-central-2" = "euce2"
    "eu-north-1"   = "euno1"
    "eu-south-1"   = "euso1"
    "eu-south-2"   = "euso2"
    # AP Regions
    "ap-southeast-1" = "apse1"
    "ap-southeast-2" = "apse2"
    "ap-southeast-3" = "apse3"
    "ap-southeast-4" = "apse4"
    "ap-southeast-5" = "apse5"
    "ap-southeast-6" = "apse6"
    "ap-southeast-7" = "apse7"
    "ap-northeast-1" = "apne1"
    "ap-northeast-2" = "apne2"
    "ap-northeast-3" = "apne3"
    "ap-south-1"     = "apso1"
    "ap-south-2"     = "apso2"
    "ap-east-1"      = "apea1"
    "ap-east-2"      = "apea2"
    # SA Regions
    "sa-east-1" = "saea1"
    # CA Regions
    "ca-central-1" = "cace1"
    "ca-west-1"    = "cawe1"
    # MX Regions
    "mx-central-1" = "mxce1"
    # ME Regions
    "me-south-1"   = "meso1"
    "me-central-1" = "mece1"
    # AF Regions
    "af-south-1" = "afso1"
    # IL Regions
    "il-central-1" = "ilce1"
  }

  region_prefix = var.region_prefix != null ? var.region_prefix : lookup(local.region_prefix_map, data.aws_region.current.region, "aws")
  name_prefix   = var.use_region_prefix ? "${local.region_prefix}-" : ""

  # VPN Gateway
  # A VPN Gateway is only used when the VPN terminates on the VPC (not on a Transit Gateway).
  # Use the explicit booleans to avoid count/for_each depending on unknown values.
  use_vpn_gateway    = var.create_vpn_gateway && !var.use_existing_transit_gateway
  create_vpn_gateway = local.use_vpn_gateway && !var.use_existing_vpn_gateway
  vpn_gateway_id = local.use_vpn_gateway ? (
    var.use_existing_vpn_gateway ? var.vpn_gateway_id : try(aws_vpn_gateway.this[0].id, null)
  ) : null

  # Customer Gateway
  # Use the explicit boolean var.use_existing_customer_gateway to avoid count depends on unknown values
  create_customer_gateway = var.create_vpn_gateway && !var.use_existing_customer_gateway && var.customer_gateway_bgp_asn != null && var.customer_gateway_ip_address != null
  customer_gateway_id     = var.use_existing_customer_gateway ? var.customer_gateway_id : try(aws_customer_gateway.this[0].id, null)

  # VPN Connection
  create_vpn_connection = var.create_vpn_gateway && (local.create_customer_gateway || var.use_existing_customer_gateway)

  # Transit Gateway
  create_transit_gateway_attachment = var.use_existing_transit_gateway && var.create_vpn_gateway

  # Tags: merge(tags_common, <specific tags>, { Name, ManagedBy })
  module_tags = {
    Module    = "terraform-aws-vpn"
    ManagedBy = "Terraform"
  }

  vpn_gateway_tags = merge(
    var.tags_common,
    var.vpn_gateway_tags,
    { Name = "${local.name_prefix}vgw-${var.account_name}-${var.project_name}" },
    local.module_tags,
  )

  customer_gateway_tags = merge(
    var.tags_common,
    var.customer_gateway_tags,
    { Name = "${local.name_prefix}cgw-${var.account_name}-${var.project_name}" },
    local.module_tags,
  )

  vpn_connection_tags = merge(
    var.tags_common,
    var.vpn_connection_tags,
    { Name = "${local.name_prefix}vpn-${var.account_name}-${var.project_name}" },
    local.module_tags,
  )

  transit_gateway_attachment_tags = merge(
    var.tags_common,
    var.transit_gateway_attachment_tags,
    { Name = "${local.name_prefix}tgw-attach-${var.account_name}-${var.project_name}" },
    local.module_tags,
  )

  # Tags for the Transit Gateway attachment that AWS creates for a TGW VPN connection
  # (aws_vpn_connection does not propagate its tags to that attachment)
  vpn_transit_gateway_attachment_tags = merge(
    var.tags_common,
    var.vpn_transit_gateway_attachment_tags,
    { Name = "${local.name_prefix}tgw-attach-vpn-${var.account_name}-${var.project_name}" },
    local.module_tags,
  )

  # Static routes
  # aws_vpn_connection_route only applies to VPN connections on a VPN Gateway
  vpn_gateway_routes = local.create_vpn_connection && local.use_vpn_gateway && var.static_routes_only && var.static_routes_destinations != null ? toset(var.static_routes_destinations) : toset([])

  # Route table IDs for propagation (VPN Gateway only) - use index-based keys to avoid unknown value issues
  private_route_table_ids = local.use_vpn_gateway && var.propagate_private_route_tables_vgw ? {
    for idx, rt_id in var.private_route_table_ids : tostring(idx) => rt_id
  } : {}
  public_route_table_ids = local.use_vpn_gateway && var.propagate_public_route_tables_vgw ? {
    for idx, rt_id in var.public_route_table_ids : tostring(idx) => rt_id
  } : {}
  intra_route_table_ids = local.use_vpn_gateway && var.propagate_intra_route_tables_vgw ? {
    for idx, rt_id in var.intra_route_table_ids : tostring(idx) => rt_id
  } : {}
  database_route_table_ids = local.use_vpn_gateway && var.propagate_database_route_tables_vgw ? {
    for idx, rt_id in var.database_route_table_ids : tostring(idx) => rt_id
  } : {}

  # Transit Gateway Route Tables (custom)
  use_custom_tgw_route_tables         = length(var.transit_gateway_route_table_association_ids) > 0 || length(var.transit_gateway_route_table_propagation_ids) > 0
  tgw_default_route_table_association = local.use_custom_tgw_route_tables ? false : var.transit_gateway_default_route_table_association
  tgw_default_route_table_propagation = local.use_custom_tgw_route_tables ? false : var.transit_gateway_default_route_table_propagation
  tgw_route_table_association_ids     = toset(var.transit_gateway_route_table_association_ids)
  tgw_route_table_propagation_ids     = toset(var.transit_gateway_route_table_propagation_ids)

  # Attachment IDs (needed for custom route table associations/propagations)
  vpc_attachment_id = try(aws_ec2_transit_gateway_vpc_attachment.this[0].id, null)
  vpn_attachment_id = try(aws_vpn_connection.this[0].transit_gateway_attachment_id, null)

  # Create sets for all combinations of route tables and attachments
  tgw_vpc_associations = local.create_transit_gateway_attachment && length(local.tgw_route_table_association_ids) > 0 ? {
    for rt_id in local.tgw_route_table_association_ids :
    "vpc-${rt_id}" => {
      route_table_id = rt_id
      attachment_id  = local.vpc_attachment_id
    }
  } : {}

  tgw_vpn_associations = local.create_vpn_connection && var.use_existing_transit_gateway && length(local.tgw_route_table_association_ids) > 0 ? {
    for rt_id in local.tgw_route_table_association_ids :
    "vpn-${rt_id}" => {
      route_table_id = rt_id
      attachment_id  = local.vpn_attachment_id
    }
  } : {}

  tgw_vpc_propagations = local.create_transit_gateway_attachment && length(local.tgw_route_table_propagation_ids) > 0 ? {
    for rt_id in local.tgw_route_table_propagation_ids :
    "vpc-${rt_id}" => {
      route_table_id = rt_id
      attachment_id  = local.vpc_attachment_id
    }
  } : {}

  tgw_vpn_propagations = local.create_vpn_connection && var.use_existing_transit_gateway && length(local.tgw_route_table_propagation_ids) > 0 ? {
    for rt_id in local.tgw_route_table_propagation_ids :
    "vpn-${rt_id}" => {
      route_table_id = rt_id
      attachment_id  = local.vpn_attachment_id
    }
  } : {}
}

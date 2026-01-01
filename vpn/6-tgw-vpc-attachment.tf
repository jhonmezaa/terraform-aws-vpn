################################################################################
# Transit Gateway VPC Attachment
################################################################################

resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  count = local.create_transit_gateway_attachment ? 1 : 0

  subnet_ids         = var.transit_gateway_subnet_ids
  transit_gateway_id = var.transit_gateway_id
  vpc_id             = var.vpc_id

  dns_support                                     = var.transit_gateway_dns_support
  ipv6_support                                    = var.transit_gateway_ipv6_support
  appliance_mode_support                          = var.transit_gateway_appliance_mode_support
  transit_gateway_default_route_table_association = local.tgw_default_route_table_association
  transit_gateway_default_route_table_propagation = local.tgw_default_route_table_propagation

  tags = local.transit_gateway_attachment_tags
}

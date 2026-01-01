################################################################################
# Transit Gateway Route Table Associations (Custom)
################################################################################

# Associate VPC attachment to custom route tables
resource "aws_ec2_transit_gateway_route_table_association" "vpc" {
  for_each = local.tgw_vpc_associations

  transit_gateway_attachment_id  = each.value.attachment_id
  transit_gateway_route_table_id = each.value.route_table_id

  depends_on = [aws_ec2_transit_gateway_vpc_attachment.this]
}

# Associate VPN attachment to custom route tables
resource "aws_ec2_transit_gateway_route_table_association" "vpn" {
  for_each = local.tgw_vpn_associations

  transit_gateway_attachment_id  = each.value.attachment_id
  transit_gateway_route_table_id = each.value.route_table_id

  # Replace existing association automatically (VPN attachments auto-associate to default route table)
  replace_existing_association = true

  depends_on = [aws_vpn_connection.this]
}

################################################################################
# Transit Gateway Route Table Propagations (Custom)
################################################################################

# Enable propagation from VPC attachment to custom route tables
resource "aws_ec2_transit_gateway_route_table_propagation" "vpc" {
  for_each = local.tgw_vpc_propagations

  transit_gateway_attachment_id  = each.value.attachment_id
  transit_gateway_route_table_id = each.value.route_table_id

  depends_on = [aws_ec2_transit_gateway_vpc_attachment.this]
}

# Enable propagation from VPN attachment to custom route tables
resource "aws_ec2_transit_gateway_route_table_propagation" "vpn" {
  for_each = local.tgw_vpn_propagations

  transit_gateway_attachment_id  = each.value.attachment_id
  transit_gateway_route_table_id = each.value.route_table_id

  depends_on = [aws_vpn_connection.this]
}

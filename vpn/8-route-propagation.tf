################################################################################
# VPN Gateway Route Propagation
################################################################################

# Private route tables
resource "aws_vpn_gateway_route_propagation" "private" {
  for_each = local.private_route_table_ids

  route_table_id = each.value
  vpn_gateway_id = local.vpn_gateway_id

  depends_on = [aws_vpn_gateway.this, aws_vpn_gateway_attachment.this]
}

# Public route tables
resource "aws_vpn_gateway_route_propagation" "public" {
  for_each = local.public_route_table_ids

  route_table_id = each.value
  vpn_gateway_id = local.vpn_gateway_id

  depends_on = [aws_vpn_gateway.this, aws_vpn_gateway_attachment.this]
}

# Intra route tables
resource "aws_vpn_gateway_route_propagation" "intra" {
  for_each = local.intra_route_table_ids

  route_table_id = each.value
  vpn_gateway_id = local.vpn_gateway_id

  depends_on = [aws_vpn_gateway.this, aws_vpn_gateway_attachment.this]
}

# Database route tables
resource "aws_vpn_gateway_route_propagation" "database" {
  for_each = local.database_route_table_ids

  route_table_id = each.value
  vpn_gateway_id = local.vpn_gateway_id

  depends_on = [aws_vpn_gateway.this, aws_vpn_gateway_attachment.this]
}

################################################################################
# VPN Connection Routes
################################################################################

# Static routes for VPN connections
resource "aws_vpn_connection_route" "this" {
  for_each = local.vpn_gateway_routes

  vpn_connection_id      = aws_vpn_connection.this[0].id
  destination_cidr_block = each.value
}

################################################################################
# Route Propagation - VPN Gateway
################################################################################

# Propagate routes to private route tables
resource "aws_vpn_gateway_route_propagation" "private" {
  for_each = local.private_route_table_ids

  route_table_id = each.value
  vpn_gateway_id = local.vpn_gateway_id

  depends_on = [aws_vpn_gateway.this, aws_vpn_gateway_attachment.this]
}

# Propagate routes to public route tables
resource "aws_vpn_gateway_route_propagation" "public" {
  for_each = local.public_route_table_ids

  route_table_id = each.value
  vpn_gateway_id = local.vpn_gateway_id

  depends_on = [aws_vpn_gateway.this, aws_vpn_gateway_attachment.this]
}

# Propagate routes to intra route tables
resource "aws_vpn_gateway_route_propagation" "intra" {
  for_each = local.intra_route_table_ids

  route_table_id = each.value
  vpn_gateway_id = local.vpn_gateway_id

  depends_on = [aws_vpn_gateway.this, aws_vpn_gateway_attachment.this]
}

# Propagate routes to database route tables
resource "aws_vpn_gateway_route_propagation" "database" {
  for_each = local.database_route_table_ids

  route_table_id = each.value
  vpn_gateway_id = local.vpn_gateway_id

  depends_on = [aws_vpn_gateway.this, aws_vpn_gateway_attachment.this]
}

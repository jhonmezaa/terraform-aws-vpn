################################################################################
# Static Routes
################################################################################

resource "aws_vpn_connection_route" "this" {
  for_each = local.vpn_gateway_routes

  destination_cidr_block = each.value
  vpn_connection_id      = aws_vpn_connection.this[0].id
}

################################################################################
# Customer Gateway
################################################################################

resource "aws_customer_gateway" "this" {
  count = local.create_customer_gateway ? 1 : 0

  bgp_asn         = var.customer_gateway_bgp_asn
  ip_address      = var.customer_gateway_ip_address
  type            = "ipsec.1"
  certificate_arn = var.customer_gateway_certificate_arn
  device_name     = var.customer_gateway_device_name

  tags = local.customer_gateway_tags
}

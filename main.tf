resource "aws_route53_record" "caa" {
  allow_overwrite = true
  zone_id         = var.zone_id
  name            = local.zone_name
  type            = "CAA"
  ttl             = 86400
  records         = local.caa_records

  lifecycle {
    create_before_destroy = false
  }
}

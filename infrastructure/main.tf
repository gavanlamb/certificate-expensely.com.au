﻿resource "aws_acm_certificate" "wildcard" {
  domain_name = var.domain_name
  subject_alternative_names = [
    "*.${var.domain_name}" ]
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    local.default_tags,
    {
      Name = var.domain_name
    }
  )
}

resource "aws_route53_record" "wildcard_validation" {
  for_each = {
  for dvo in aws_acm_certificate.wildcard.domain_validation_options : dvo.domain_name => {
    name = dvo.resource_record_name
    record = dvo.resource_record_value
    type = dvo.resource_record_type
  }
  }

  allow_overwrite = true
  name = each.value.name
  records = [each.value.record]
  ttl = 60
  type = each.value.type
  zone_id = data.aws_route53_zone.zone.zone_id
}

resource "aws_acm_certificate_validation" "wildcard" {
  certificate_arn         = aws_acm_certificate.wildcard.arn
  validation_record_fqdns = [for record in aws_route53_record.wildcard_validation : record.fqdn]
}

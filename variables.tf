data "aws_route53_zone" "zone" {
  zone_id = var.zone_id
}

variable "zone_id" {
  description = "AWS Route53 Hosted Zone ID"
  type        = string
}

variable "caa_issuers" {
  description = "List of CA authorized to issue certificates"
  type        = list(string)
  default     = []
}

variable "caa_report_recipient" {
  description = "Recipient of CAA reports"
  type        = string
  default     = null
}

locals {
  zone_name            = data.aws_route53_zone.zone.name
  caa_report_recipient = var.caa_report_recipient != null ? var.caa_report_recipient : format("hostmaster@%s", local.zone_name)
  caa_records = flatten(
    [
      "0 issue \";\"",
      [for issuer in var.caa_issuers : format("0 issue \"%s\"", issuer)],
      format("0 iodef \"mailto:%s\"", local.caa_report_recipient),
    ]
  )
}

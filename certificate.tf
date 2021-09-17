data "aws_route53_zone" "this" {
  name         = var.domain_name
  private_zone = false
}


module "acm" {
  #count = var.self_signed_cert || !var.create_certificate ? 0 : 1
  count = !var.self_signed_cert && var.create_certificate ? 1 : 0

  source      = "terraform-aws-modules/acm/aws"
  version     = "3.2.0"
  domain_name = var.domain_name
  zone_id     = data.aws_route53_zone.this.zone_id

  subject_alternative_names = [
    "*.${var.domain_name}",
  ]


  wait_for_validation = false

  tags = merge(local.common_tags, {
    Name = var.domain_name
  })
}



resource "null_resource" "wait_for_certificate_validation" {
  count = var.self_signed_cert || !var.create_certificate ? 0 : 1
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = "python3 scripts/wait_for_validation.py  --timeout ${var.cert_validation_timeout} --certificate-arn ${module.acm.0.acm_certificate_arn}"
  }
}





##### Outputs ########

output "certificate_arn" {
  description = "The certificate ARN"
  value       = var.self_signed_cert ? null : module.acm.0.acm_certificate_arn
}

output "validation_route53_record_fqdns" {
  description = "List of FQDNs built using the zone domain and name."
  value       = var.self_signed_cert ? null : module.acm.0.validation_route53_record_fqdns
}

output "distinct_domain_names" {
  description = "List of distinct domains names used for the validation."
  value       = var.self_signed_cert ? null : module.acm.0.distinct_domain_names
}

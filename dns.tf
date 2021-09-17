resource "aws_route53_record" "app" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = join(".", [var.app_name, data.aws_route53_zone.this.name])
  type    = "A"
  alias {
    name                   = module.alb.lb_dns_name
    zone_id                = module.alb.lb_zone_id
    evaluate_target_health = true
  }
}



##### Outputs ########

output "app_fqdn" {
  value = aws_route53_record.app.fqdn
}

output "app_url" {
  value = format("https://%s:443", aws_route53_record.app.fqdn)
}


resource "tls_private_key" "example" {
  count     = var.self_signed_cert && var.create_certificate ? 1 : 0
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "example" {
  count           = var.self_signed_cert && var.create_certificate ? 1 : 0
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.example.0.private_key_pem

  subject {
    common_name  = var.domain_name
    organization = "ACME Examples, Inc"
  }

  dns_names = ["*.${var.domain_name}"]

  validity_period_hours = 12

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "aws_acm_certificate" "self_signed_cert" {
  count            = var.self_signed_cert && var.create_certificate ? 1 : 0
  private_key      = tls_private_key.example.0.private_key_pem
  certificate_body = tls_self_signed_cert.example.0.cert_pem

  tags = merge(local.common_tags, {
    Name = var.domain_name
  })

}

output "self_signed_certificate_arn" {
  description = "The certificate ARN"
  value       = var.self_signed_cert && var.create_certificate ? aws_acm_certificate.self_signed_cert.0.arn : null
}


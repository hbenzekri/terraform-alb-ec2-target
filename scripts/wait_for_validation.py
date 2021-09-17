import boto3
import argparse
import sys
parser = argparse.ArgumentParser()
parser.add_argument("--certificate-arn", help="The ACM certificate ARN")
parser.add_argument("--timeout", type=int, help="The timeout period for the certificate validation (in minutes)")
args = parser.parse_args()
if not args.certificate_arn:
    sys.exit("arguemnt --certificate-arn not found")

if not args.timeout:
    sys.exit("arguemnt --timeout not found")

client_acm = boto3.client('acm')

waiter = client_acm.get_waiter('certificate_validated')

#Two hours wait period
waiter.wait(
    CertificateArn=args.certificate_arn,
    WaiterConfig={
        'Delay': 60,
        'MaxAttempts': args.timeout + 1
    }
)


locals {
  certificate_arn = var.create_certificate ? (var.self_signed_cert  ? aws_acm_certificate.self_signed_cert.0.arn : module.acm.0.acm_certificate_arn): var.user_provided_certificate_arn
}
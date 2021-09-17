variable "app_name" {
  type    = string
  default = "my-app"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "instance_keypair" {
  type = string

}

variable "create_bastion" {
  type    = bool
  default = false
}

variable "user_public_ip" {
  type        = string
  description = "the user public ip, only this ip will be allowed to ssh to the bastion (used only when create_bastion is true)"
  default     = ""
}

variable "bastion_instance_type" {
  description = "used only when create_bastion is true "
  default     = "t2.micro"
}

variable "vpc_name" {
  default = "my_vpc"
}

variable "vpc_cidr" {
  description = "The vpc cidr"
}

variable "vpc_availability_zones" {
  type        = list(string)
  description = "the vpc availability zones"
  validation {
    condition     = length(var.vpc_availability_zones) > 1
    error_message = "The vpc_availability_zones must contain at least two elements."
  }
}

variable "vpc_private_subnets" {
  type        = list(string)
  description = "the private subnets for the lb target ec2 instances (two should be provided)"
  validation {
    condition     = length(var.vpc_private_subnets) > 1
    error_message = "The vpc_private_subnets value must contain at least two elements."
  }
}

variable "vpc_public_subnets" {
  type        = list(string)
  description = "the public subnet for the bastion host and alb (two should be provided)"
  validation {
    condition     = length(var.vpc_public_subnets) > 1
    error_message = "The vpc_public_subnets value must contain at least two elements."
  }
}

#only used when create_vpc is true
variable "vpc_single_nat_gateway" {
  default = false
}
#only used when create_vpc is true
variable "vpc_enable_nat_gateway" {
  default = true
}

variable "domain_name" {
  description = "The route 53 domain or subdomain (used to record the ALB name)"
}


variable "create_certificate" {
  description = "Create a certificate (Self signed or Amazon issued) or provide an already existing certificate ARN"
  default     = true
  type        = bool
}

variable "user_provided_certificate_arn" {
  description = "Provide a certificate ARN to use for ALB listener (when create_certificate is set to false)"
  default     = ""
  type        = string
}


variable "self_signed_cert" {
  description = "import self signed cert to ACM (for testing puroposes)"
  default     = false
  type        = bool
}

variable "cert_validation_timeout" {
  description = "The timeout in minutes for the certificate validation (when create_certificate is set to true and self_signed_cert is set to false)."
  default     = 90
  type        = number
  validation {
    condition     = var.cert_validation_timeout >= 1
    error_message = "The cert_validation_timeout value must be equal or greater than 1."
  }
}

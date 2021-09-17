vpc_name = "alb_prd_vpc"
vpc_cidr = "10.10.0.0/16"
vpc_availability_zones = ["us-east-1a", "us-east-1b"]
vpc_public_subnets= ["10.10.104.0/24", "10.10.105.0/24"]
vpc_private_subnets = ["10.10.102.0/24", "10.10.103.0/24"]

#only used when create_vpc is true
vpc_enable_nat_gateway = true  
vpc_single_nat_gateway = true
app_name = "app"
environment = "prd"
instance_keypair= "app-keypair"
create_bastion = false
#user_public_ip = "41.62.92.178"

domain_name = "test14852179698.com"
self_signed_cert = false
create_certificate = true
#user_provided_certificate_arn= 
cert_validation_timeout= 180
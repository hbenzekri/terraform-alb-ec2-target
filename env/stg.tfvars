vpc_name = "alb_stg_vpc"
vpc_cidr = "10.7.0.0/16"
vpc_availability_zones = ["us-east-1a", "us-east-1b"]
vpc_public_subnets= ["10.7.104.0/24", "10.7.105.0/24"]
vpc_private_subnets = ["10.7.102.0/24", "10.7.103.0/24"]

#only used when create_vpc is true
vpc_enable_nat_gateway = true  
vpc_single_nat_gateway = true
app_name = "my-app"
environment = "stg"
instance_keypair= "my-app-keypair"
create_bastion = false
#user_public_ip = "41.62.92.178"

domain_name = "test14852179698.com"
create_certificate = false

user_provided_certificate_arn= "arn:aws:acm:us-east-1:545719576016:certificate/687566c9-b0ec-4823-940a-53f1dd088f77"
self_signed_cert = true
cert_validation_timeout= 180

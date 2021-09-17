vpc_name = "alb_dev_vpc"
vpc_cidr = "10.5.0.0/16"
vpc_availability_zones = ["us-east-1a", "us-east-1b"]
vpc_public_subnets= ["10.5.104.0/24", "10.5.110.0/24"]
vpc_private_subnets = ["10.5.102.0/24", "10.5.103.0/24"]

#only used when create_vpc is true
vpc_enable_nat_gateway = true  
vpc_single_nat_gateway = true
#vpc_id
app_name = "my-app"
environment = "dev"
instance_keypair= "my-app-keypair"
create_bastion = false
#user_public_ip = "41.62.92.178"

domain_name = "dev.test14852179698.com"
create_certificate = true
#user_provided_certificate_arn= 
self_signed_cert = true
cert_validation_timeout= 180

locals {
  multiple_instances = {
    one = {
      instance_type     = "t2.micro"
      availability_zone = element(module.vpc.azs, 0)
      subnet_id         = element(module.vpc.private_subnets, 0)
      #   root_block_device = [
      #     {
      #       encrypted   = true
      #       volume_type = "gp3"
      #       throughput  = 200
      #       volume_size = 50
      #     }
      #   ]
    }
    two = {
      instance_type     = "t2.micro"
      availability_zone = element(module.vpc.azs, 1)
      subnet_id         = element(module.vpc.private_subnets, 1)
      #   root_block_device = [
      #     {
      #       encrypted   = true
      #       volume_type = "gp2"
      #       volume_size = 50
      #     }
      #   ]
    }


  }

}

data "aws_ami" "amzlinux2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }
  #   filter {
  #     name = "root-device-type"
  #     values = [ "ebs" ]
  #   }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}



module "ec2_private" {
  depends_on = [module.vpc]
  for_each   = local.multiple_instances
  source     = "terraform-aws-modules/ec2-instance/aws"
  version    = "3.1.0"

  name                   = "${var.app_name}-${var.environment}-${each.key}"
  key_name               = var.instance_keypair
  ami                    = data.aws_ami.amzlinux2.id
  instance_type          = each.value.instance_type
  availability_zone      = each.value.availability_zone
  subnet_id              = each.value.subnet_id
  vpc_security_group_ids = [module.private_sg.security_group_id]

  enable_volume_tags = true
  root_block_device  = lookup(each.value, "root_block_device", [])

  user_data = templatefile("${path.root}/scripts/init.sh", {
    environment = var.environment
    ec2_name    = "${var.app_name}-${var.environment}-${each.key}"
  })

  tags = local.common_tags
}


##bastion
module "ec2_public" {
  count                  = var.create_bastion ? 1 : 0
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "3.1.0"
  name                   = "${var.app_name}-${var.environment}-BastionHost"
  ami                    = data.aws_ami.amzlinux2.id
  instance_type          = var.bastion_instance_type
  key_name               = var.instance_keypair
  subnet_id              = element(module.vpc.public_subnets, 0)
  vpc_security_group_ids = [module.public_bastion_sg.0.security_group_id]
  tags                   = local.common_tags
}

#security group for private ec2 instances
module "private_sg" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "4.3.0"
  name        = "private-sg"
  description = "Security Group with HTTP & SSH port open for entire VPC Block (IPv4 CIDR), egress ports are all world open"
  vpc_id      = module.vpc.vpc_id
  # Ingress Rules & CIDR Blocks
  ingress_rules       = ["ssh-tcp", "http-80-tcp"]
  ingress_cidr_blocks = [module.vpc.vpc_cidr_block]
  # Egress Rule - all-all open
  egress_rules = ["all-all"]
  tags         = local.common_tags
}

#security group for bastion host
module "public_bastion_sg" {

  count   = var.create_bastion ? 1 : 0
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.3.0"

  name        = "public-bastion-sg"
  description = "Security Group with SSH port open for everybody (IPv4 CIDR), egress ports are all world open"
  vpc_id      = module.vpc.vpc_id
  # Ingress Rules & CIDR Blocks
  ingress_rules       = ["ssh-tcp"]
  ingress_cidr_blocks = [format("%s/%s", var.user_public_ip, "32")]
  # Egress Rule - all-all open
  egress_rules = ["all-all"]
  tags         = local.common_tags
}


##### Outputs ########

output "ec2_bastion_public_instance_ids" {
  description = "List of IDs of instances"
  value       = var.create_bastion ? module.ec2_public.0.id : null
}

## ec2_bastion_public_ip
output "ec2_bastion_public_ip" {
  description = "List of public IP addresses assigned to the instances"
  value       = var.create_bastion ? module.ec2_public.0.public_ip : null
}

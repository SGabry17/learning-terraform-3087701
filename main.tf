data "aws_ami" "app_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["bitnami-tomcat-*-x86_64-hvm-ebs-nami"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["979382823631"] # Bitnami
}

data "aws_vpc" "default"{
  default = true
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.app_ami.id
  instance_type = var.instance_type

  vpc_security_group_ids = [module.blog_sg.security_group_id]

  tags = {
    Name = "HelloWorld"
  }
}



module "blog_sg" {
  source            = "terraform-aws-modules/security-group/aws"
  version           = "4.17.2"
  name              = "blog_new"
  ingress_rule      = ["http-80-tcp", "https-443-tcp"]
  ingress_cidr_rule = ["0.0.0.0/0"]
  egress_rule      = ["all-all"]
  egress_cidr_rule = ["0.0.0.0/0"]
  vpc_id            = data.aws_vpc.default.id
}


################################################################################
# Create Security Groups
################################################################################


resource "aws_security_group" "TEST-General-sg" {
  name        = "${var.env_name}_TEST-General-sg"
  description = "Security Group for Bastion Host in ${var.env_name} env"
  vpc_id      = module.dev-general-vpc.vpc_id

  ingress {
    cidr_blocks = var.ssh_pub_ip_list
    description = "SSh Access from Public IP Addresses"
    from_port   = "22"
    protocol    = "tcp"
    self        = "false"
    to_port     = "22"
  }

  ingress {
    cidr_blocks = var.rdp_pub_ip_list
    description = "RDP Access from Public IP Addresses"
    from_port   = "3389"
    protocol    = "tcp"
    self        = "false"
    to_port     = "3389"
  }

  // Why this is not in code, Unhash if someone will scream for it.
  // ingress {
  //   cidr_blocks = "39.41.126.3/32"
  //   description = "ET-D"
  //   from_port   = "3389"
  //   protocol    = "tcp"
  //   self        = "false"
  //   to_port     = "3389"
  // }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "TEST-dev-rds-sg" {
  name        = "${var.env_name}_dev-rds-sg"
  description = "Security Group for the RDS Instance in ${var.env_name}"
  vpc_id      = module.dev-secure_vpc.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.TEST-rpasvr-sg.id]
    self            = false
  }

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.TEST-secure-api-svr-sg.id]
    self            = false
  }

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.TEST-rpaagt1-sg.id]
    self            = false
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "TEST-ELB-Web-Secure" {
  name        = "${var.env_name}_ELB-Web-Secure"
  description = "Public facing ELB Security Group"
  vpc_id      = module.dev-secure_vpc.vpc_id

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

# remove this. It is only to check health check on port 80
    ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "TEST-secure-api-svr-sg" {
  name        = "secure-api-svr-sg"
  description = "APISVR Security group to receive traffic from ELB in ${var.env_name} env"
  vpc_id      = module.dev-secure_vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "TEST-Management" {
  name        = "${var.env_name}_Management"
  description = "SSH Access"
  vpc_id      = module.dev-secure_vpc.vpc_id

  ingress {
    cidr_blocks = ["192.168.11.23/32"] #TO DO: UPDATE THIS ["${aws_instance.bastion_host[0].private_ip}/32"]
    from_port   = "22"
    protocol    = "tcp"
    self        = "false"
    to_port     = "22"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "aws_security_group" "TEST-rpasvr-sg" {
  name        = "${var.env_name}_rpasvr-sg"
  description = "Security Group for RPA Server"
  vpc_id      = module.dev-secure_vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}




resource "aws_security_group" "TEST-rpaagt1-sg" {
  name        = "${var.env_name}_rpaagt1-sg"
  description = "Security Group for RPAAGT1 Server"
  vpc_id      = module.dev-secure_vpc.vpc_id

  ingress {
    from_port       = 8441
    to_port         = 8450
    protocol        = "tcp"
    security_groups = [aws_security_group.TEST-rpasvr-sg.id]
    self            = false
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.TEST-rpasvr-sg.id]
    self            = false
  }

  ingress {
    from_port       = 3389
    to_port         = 3389
    protocol        = "tcp"
    security_groups = [aws_security_group.TEST-General-sg.id]
    self            = false
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group_rule" "TEST-secure-api-svr-sg" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.TEST-secure-api-svr-sg.id
  source_security_group_id = aws_security_group.TEST-rpasvr-sg.id
}

resource "aws_security_group_rule" "TEST-rpasvr-sg" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.TEST-rpasvr-sg.id
  source_security_group_id = aws_security_group.TEST-rpaagt1-sg.id
}


resource "aws_security_group_rule" "TEST-rpasvr-sg-ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.TEST-rpasvr-sg.id
  source_security_group_id = aws_security_group.TEST-General-sg.id
}


resource "aws_security_group_rule" "TEST-rpasvr-sg-ssl" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.TEST-rpasvr-sg.id
  source_security_group_id = aws_security_group.TEST-General-sg.id
}



resource "aws_security_group_rule" "TEST-secure-api-svr-elb-sg" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.TEST-secure-api-svr-sg.id
  source_security_group_id = aws_security_group.TEST-ELB-Web-Secure.id
}


resource "aws_security_group_rule" "TEST-secure-api-svr-elb-elb1-sg" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.TEST-secure-api-svr-sg.id
  source_security_group_id = aws_security_group.TEST-ELB-Web-Secure.id
}
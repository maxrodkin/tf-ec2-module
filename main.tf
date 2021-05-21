provider "aws" {
  region     = var.region
  access_key = "AKIAZMVS4UFITMFQHFEU"
  secret_key = "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"
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc-cidr
  enable_dns_hostnames = true
}

resource "aws_subnet" "subnets" {
    count = var.subnets_count

    vpc_id            = aws_vpc.vpc.id
    cidr_block        = local.subnets_list[count.index].cidr
    availability_zone = "${var.region}${local.subnets_list[count.index].zone}"
}

/*
resource "aws_subnet" "subnet-a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet-cidr-a
  availability_zone = "${var.region}a"
}

resource "aws_subnet" "subnet-b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet-cidr-b
  availability_zone = "${var.region}b"
}

resource "aws_subnet" "subnet-c" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet-cidr-c
  availability_zone = "${var.region}c"
}
*/

resource "aws_route_table" "subnet-route-table" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route" "subnet-route" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
  route_table_id         = aws_route_table.subnet-route-table.id
}

resource "aws_route_table_association" "subnet-all-route-table-associations" {
  count = length(aws_subnet.subnets)

  subnet_id      = aws_subnet.subnets[count.index].id
  route_table_id = aws_route_table.subnet-route-table.id
}
/*
resource "aws_route_table_association" "subnet-a-route-table-association" {
  subnet_id      = aws_subnet.subnet-a.id
  route_table_id = aws_route_table.subnet-route-table.id
}

resource "aws_route_table_association" "subnet-b-route-table-association" {
  subnet_id      = aws_subnet.subnet-b.id
  route_table_id = aws_route_table.subnet-route-table.id
}

resource "aws_route_table_association" "subnet-c-route-table-association" {
  subnet_id      = aws_subnet.subnet-c.id
  route_table_id = aws_route_table.subnet-route-table.id
}
*/

resource "aws_instance" "instance" {
  count = 2
  #  ami                         = "ami-cdbfa4ab"
  ami                         = data.aws_ami.example.id
  instance_type               = "t2.small"
  vpc_security_group_ids      = [aws_security_group.security-group.id]
#  subnet_id                   = aws_subnet.subnet-a.id
  subnet_id = aws_subnet.subnets[0].id
  associate_public_ip_address = true
  user_data                   = <<EOF
#!/bin/sh
yum install -y nginx
service nginx start
EOF
}

resource "aws_security_group" "security-group" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "nginx_domain" {
  value = aws_instance.instance.*.public_dns
}

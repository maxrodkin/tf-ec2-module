data "aws_ami" "example" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-ebs"]
  }
}

data "aws_availability_zones" "available" {}

output "availability_zones"{
  value = data.aws_availability_zones.available
}

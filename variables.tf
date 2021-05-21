variable "region" {
}

variable "vpc-cidr" {}

variable "subnet-cidr-a" {}

variable "subnet-cidr-b" {}

variable "subnet-cidr-c" {}

variable "subnet-cidr-d" {default = null}

variable "subnets_count" {}

locals {
  subnets_list= [
    {zone = "a" , cidr = var.subnet-cidr-a},
    {zone = "b" , cidr = var.subnet-cidr-b},
    {zone = "c" , cidr = var.subnet-cidr-c},
    {zone = "d" , cidr = var.subnet-cidr-d}
  ]
}


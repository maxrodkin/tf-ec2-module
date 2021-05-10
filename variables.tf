variable "region" {
}

variable "vpc-cidr" {}

variable "subnet-cidr-a" {}

variable "subnet-cidr-b" {}

variable "subnet-cidr-c" {}

variable "subnet-cidr-d" {default = null}

variable "subnets_count" {}

locals {
  subnets_list= {
    "a" = var.subnet-cidr-a
    "b" = var.subnet-cidr-b
    "c" = var.subnet-cidr-c
    "d" = var.subnet-cidr-d
  }
}


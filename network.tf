###############################
# VPC
###############################
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  
  tags = {
    Name = "sbcntr-main"
  }
}

###############################
# サブネット(Ingress用)
###############################
resource "aws_subnet" "sbcntr-public-ingress-a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "sbcntr-public-ingress-a"
  }
}

resource "aws_subnet" "sbcntr-public-ingress-c" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "sbcntr-public-ingress-c"
  }
}

###############################
# サブネット(アプリケーション用)
###############################
resource "aws_subnet" "sbcntr-private-app-a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.8.0/24"

  tags = {
    Name = "sbcntr-private-app-a"
  }
}

resource "aws_subnet" "sbcntr-private-app-c" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.9.0/24"

  tags = {
    Name = "sbcntr-private-app-c"
  }
}

###############################
# サブネット(DB用)
###############################
resource "aws_subnet" "sbcntr-private-db-a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.16.0/24"

  tags = {
    Name = "sbcntr-private-db-a"
  }
}

resource "aws_subnet" "sbcntr-private-db-c" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.17.0/24"

  tags = {
    Name = "sbcntr-private-db-c"
  }
}

###############################
# サブネット(管理用)
###############################
resource "aws_subnet" "sbcntr-public-management-a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.240.0/24"

  tags = {
    Name = "sbcntr-public-management-a"
  }
}

###############################
# サブネット(管理用予備)
###############################
resource "aws_subnet" "sbcntr-public-management-c" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.241.0/24"

  tags = {
    Name = "sbcntr-public-management-c"
  }
}

###############################
# Egress用
###############################
resource "aws_subnet" "sbcntr-private-egress-a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.248.0/24"

  tags = {
    Name = "sbcntr-private-egress-a"
  }
}

resource "aws_subnet" "sbcntr-private-egress-c" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.249.0/24"

  tags = {
    Name = "sbcntr-private-egress-c"
  }
}

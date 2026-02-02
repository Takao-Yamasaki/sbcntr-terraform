###############################
# VPC
###############################
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "sbcntr-main"
  }
}

###############################
# IGW
###############################
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

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
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "sbcntr-public-ingress-a"
  }
}

resource "aws_subnet" "sbcntr-public-ingress-c" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "sbcntr-public-ingress-c"
  }
}

###############################
# ルートテーブル(Ingress用)
###############################
resource "aws_route_table" "sbcntr-ingress" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "sbcntr-ingress"
  }
}

# Ingressサブネットへルート紐付け
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
resource "aws_route_table_association" "sbcntr-ingress-a" {
  subnet_id      = aws_subnet.sbcntr-public-ingress-a.id
  route_table_id = aws_route_table.sbcntr-ingress.id
}

## Ingressサブネットへルート紐付け
resource "aws_route_table_association" "sbcntr-ingress-c" {
  subnet_id      = aws_subnet.sbcntr-public-ingress-c.id
  route_table_id = aws_route_table.sbcntr-ingress.id
}

## Ingressルートテーブルのデフォルトルート
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route
resource "aws_route" "sbcntr-ingress-default" {
  route_table_id         = aws_route_table.sbcntr-ingress.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

###############################
# サブネット(アプリケーション用)
###############################
resource "aws_subnet" "sbcntr-private-app-a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.8.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "sbcntr-private-app-a"
  }
}

resource "aws_subnet" "sbcntr-private-app-c" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.9.0/24"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "sbcntr-private-app-c"
  }
}

###############################
# ルートテーブル(アプリケーション用)
###############################
resource "aws_route_table" "sbcntr-app" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "sbcntr-app"
  }
}

resource "aws_route_table_association" "sbcntr-app" {
  subnet_id      = aws_subnet.sbcntr-private-app-a.id
  route_table_id = aws_route_table.sbcntr-app.id
}

###############################
# サブネット(DB用)
###############################
resource "aws_subnet" "sbcntr-private-db-a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.16.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "sbcntr-private-db-a"
  }
}

resource "aws_subnet" "sbcntr-private-db-c" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.17.0/24"
  availability_zone = "ap-northeast-1c"

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
  availability_zone = "ap-northeast-1a"

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
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "sbcntr-public-management-c"
  }
}

###############################
# サブネット(Egress用)
###############################
resource "aws_subnet" "sbcntr-private-egress-a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.248.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "sbcntr-private-egress-a"
  }
}

resource "aws_subnet" "sbcntr-private-egress-c" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.249.0/24"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "sbcntr-private-egress-c"
  }
}

###############################
# SG(Ingress用)
###############################
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "sbcntr-ingress" {
  name        = "sbcntr-ingress"
  description = "Security group for ingress"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "sbcntr-ingress"
  }
}

resource "aws_vpc_security_group_ingress_rule" "sbcntr-ingress" {
  security_group_id = aws_security_group.sbcntr-ingress.id
  cidr_ipv4         = aws_vpc.main.cidr_block
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "sbcntr-ingress" {
  security_group_id = aws_security_group.sbcntr-ingress.id
  description = "Allow all outbound traffic by default"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

###############################
# SG(管理用)
###############################
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "sbcntr-management" {
  name        = "sbcntr-management"
  description = "Security group for management"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "sbcntr-management"
  }
}

resource "aws_vpc_security_group_egress_rule" "sbcntr-management" {
  security_group_id = aws_security_group.sbcntr-management.id
  description = "Allow all outbound traffic by default"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

###############################
# SG(バックエンドコンテナ用)
###############################
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "sbcntr-backend-app" {
  name        = "sbcntr-backend-app"
  description = "Security group for backend app"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "sbcntr-backend-app"
  }
}

## Frontend app -> Backend app
resource "aws_vpc_security_group_ingress_rule" "sbcntr-backend-app" {
  security_group_id        = aws_security_group.sbcntr-backend-app.id
  referenced_security_group_id = aws_security_group.sbcntr-frontend-app.id
  description = "HTTP for frontend"
  from_port                = 8081
  ip_protocol              = "tcp"
  to_port                  = 8081
}

resource "aws_vpc_security_group_egress_rule" "sbcntr-backend-app" {
  security_group_id = aws_security_group.sbcntr-backend-app.id
  description = "Allow all outbound traffic by default"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

###############################
# SG(フロントエンドエンドコンテナ用)
###############################
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "sbcntr-frontend-app" {
  name        = "sbcntr-frontend-app"
  description = "Security group for frontend app"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "sbcntr-frontend-app"
  }
}

## Internet LB -> Frontend app
resource "aws_vpc_security_group_ingress_rule" "sbcntr-frontend-app" {
  security_group_id        = aws_security_group.sbcntr-frontend-app.id
  referenced_security_group_id = aws_security_group.sbcntr-ingress.id
  description = "HTTP for Ingress"
  from_port                = 8080
  ip_protocol              = "tcp"
  to_port                  = 8080
}

resource "aws_vpc_security_group_egress_rule" "sbcntr-frontend-app" {
  security_group_id = aws_security_group.sbcntr-frontend-app.id
  description = "Allow all outbound traffic by default"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

###############################
# SG(DB用)
###############################
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "sbcntr-db" {
  name        = "sbcntr-db"
  description = "Security group for db"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "sbcntr-db"
  }
}

## Backend app -> DB
resource "aws_vpc_security_group_ingress_rule" "sbcntr-db-backend" {
  security_group_id        = aws_security_group.sbcntr-db.id
  referenced_security_group_id = aws_security_group.sbcntr-backend-app.id
  description = "PostgreSQL protocol from backend App"
  from_port                = 5432
  ip_protocol              = "tcp"
  to_port                  = 5432
}

## Management server -> DB
resource "aws_vpc_security_group_ingress_rule" "sbcntr-db-management" {
  security_group_id        = aws_security_group.sbcntr-db.id
  referenced_security_group_id = aws_security_group.sbcntr-management.id
  description = "PostgreSQL protocol from management server"
  from_port                = 5432
  ip_protocol              = "tcp"
  to_port                  = 5432
}

resource "aws_vpc_security_group_egress_rule" "sbcntr-db" {
  security_group_id = aws_security_group.sbcntr-db.id
  description = "Allow all outbound traffic by default"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

###############################
# SG(VPCエンドポイント用)
###############################
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "sbcntr-vpce" {
  name        = "sbcntr-vpce"
  description = "Security group for VPC Endpoint"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "sbcntr-vpce"
  }
}

## Backend app -> VPC endpoint
resource "aws_vpc_security_group_ingress_rule" "sbcntr-vpce-backend" {
  security_group_id        = aws_security_group.sbcntr-vpce.id
  referenced_security_group_id = aws_security_group.sbcntr-backend-app.id
  description = "HTTPS for backend app"
  from_port                = 443
  ip_protocol              = "tcp"
  to_port                  = 443
}

## Frontend app -> VPC endpoint
resource "aws_vpc_security_group_ingress_rule" "sbcntr-vpce-frontend" {
  security_group_id        = aws_security_group.sbcntr-vpce.id
  referenced_security_group_id = aws_security_group.sbcntr-frontend-app.id
  description = "HTTPS for Frontend app"
  from_port                = 443
  ip_protocol              = "tcp"
  to_port                  = 443
}

## Management server -> VPC endpoint
resource "aws_vpc_security_group_ingress_rule" "sbcntr-vpce-management" {
  security_group_id        = aws_security_group.sbcntr-vpce.id
  referenced_security_group_id = aws_security_group.sbcntr-management.id
  description = "HTTPS for management server"
  from_port                = 443
  ip_protocol              = "tcp"
  to_port                  = 443
}

resource "aws_vpc_security_group_egress_rule" "sbcntr-vpce" {
  security_group_id = aws_security_group.sbcntr-vpce.id
  description = "Allow all outbound traffic by default"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

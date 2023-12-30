resource "aws_vpc_endpoint" "ecr-api-ep" {
  service_name        = "com.amazonaws.ap-northeast-1.ecr.api"
  vpc_id              = aws_vpc.vpc.id
  vpc_endpoint_type   = "Interface"
  ip_address_type     = "ipv4"
  private_dns_enabled = true
  security_group_ids = [
    aws_vpc.vpc.default_security_group_id, aws_security_group.private-link-sg.id
  ]
  subnet_ids = [aws_subnet.private-1a.id, aws_subnet.private-1c.id]

  policy = jsonencode(
    {
      Statement = [
        {
          Action    = "*"
          Effect    = "Allow"
          Principal = "*"
          Resource  = "*"
        },
      ]
    }
  )


  tags = {
    Name = "ecr-api-ep"
  }
}
resource "aws_vpc_endpoint" "ecr-dkr-ep" {
  service_name        = "com.amazonaws.ap-northeast-1.ecr.dkr"
  vpc_id              = aws_vpc.vpc.id
  subnet_ids          = [aws_subnet.private-1a.id, aws_subnet.private-1c.id]
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  ip_address_type     = "ipv4"
  security_group_ids = [
    aws_vpc.vpc.default_security_group_id, aws_security_group.private-link-sg.id
  ]


  policy = jsonencode(
    {
      Statement = [
        {
          Action    = "*"
          Effect    = "Allow"
          Principal = "*"
          Resource  = "*"
        },
      ]
    }
  )
  tags = {
    Name = "ecr-dkr-ep"
  }
}
resource "aws_vpc_endpoint" "ssm-ep" {
  service_name        = "com.amazonaws.ap-northeast-1.ssm"
  vpc_id              = aws_vpc.vpc.id
  private_dns_enabled = true
  vpc_endpoint_type   = "Interface"
  ip_address_type     = "ipv4"
  security_group_ids = [
    aws_vpc.vpc.default_security_group_id, aws_security_group.private-link-sg.id
  ]
  subnet_ids = [aws_subnet.private-1a.id, aws_subnet.private-1c.id]

  policy = jsonencode(
    {
      Statement = [
        {
          Action    = "*"
          Effect    = "Allow"
          Principal = "*"
          Resource  = "*"
        },
      ]
    }
  )
  tags = {
    Name = "ssm-ep"
  }
}
resource "aws_vpc_endpoint" "logs-ep" {
  service_name        = "com.amazonaws.ap-northeast-1.logs"
  vpc_id              = aws_vpc.vpc.id
  private_dns_enabled = true
  ip_address_type     = "ipv4"
  vpc_endpoint_type   = "Interface"
  security_group_ids = [
    aws_vpc.vpc.default_security_group_id, aws_security_group.private-link-sg.id
  ]
  subnet_ids = [aws_subnet.private-1a.id, aws_subnet.private-1c.id]

  policy = jsonencode(
    {
      Statement = [
        {
          Action    = "*"
          Effect    = "Allow"
          Principal = "*"
          Resource  = "*"
        },
      ]
    }
  )
  tags = {
    Name = "logs-ep"
  }
}
resource "aws_vpc_endpoint" "secret-manager-ep" {
  service_name        = "com.amazonaws.ap-northeast-1.secretsmanager"
  vpc_id              = aws_vpc.vpc.id
  private_dns_enabled = true
  vpc_endpoint_type   = "Interface"
  ip_address_type     = "ipv4"
  security_group_ids = [
    aws_vpc.vpc.default_security_group_id, aws_security_group.private-link-sg.id
  ]
  subnet_ids = [aws_subnet.private-1a.id, aws_subnet.private-1c.id]

  policy = jsonencode(
    {
      Statement = [
        {
          Action    = "*"
          Effect    = "Allow"
          Principal = "*"
          Resource  = "*"
        },
      ]
    }
  )
  tags = {
    Name = "secret-manager-ep"
  }
}

resource "aws_vpc_endpoint" "s3-ep" {
  service_name        = "com.amazonaws.ap-northeast-1.s3"
  vpc_id              = aws_vpc.vpc.id
  vpc_endpoint_type   = "Gateway"
  private_dns_enabled = false
  route_table_ids = [
    aws_route_table.public-rt.id,
    aws_route_table.private-1a.id,
    aws_route_table.private-1c.id,
    aws_vpc.vpc.default_route_table_id
  ]
  policy = jsonencode(
    {
      Statement = [
        {
          Action    = "*"
          Effect    = "Allow"
          Principal = "*"
          Resource  = "*"
        },
      ]
      Version = "2008-10-17"
    }
  )
  tags = {
    Name = "s3-ep"
  }
}

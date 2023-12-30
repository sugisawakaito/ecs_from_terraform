resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "public-rt"
  }
}

resource "aws_route" "route_igw" {
  route_table_id         = aws_route_table.public-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
  depends_on             = [aws_route_table.public-rt]
}

resource "aws_route_table_association" "public-1a" {
  route_table_id = aws_route_table.public-rt.id
  subnet_id      = aws_subnet.public-1a.id
}

resource "aws_route_table_association" "public-1c" {
  route_table_id = aws_route_table.public-rt.id
  subnet_id      = aws_subnet.public-1c.id
}

resource "aws_route_table" "private-1a" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "private-1a"
  }
}

resource "aws_route_table_association" "private-1a" {
  route_table_id = aws_route_table.private-1a.id
  subnet_id      = aws_subnet.private-1a.id
}

resource "aws_route_table" "private-1c" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "private-1c"
  }
}

resource "aws_route_table_association" "private-1c" {
  route_table_id = aws_route_table.private-1c.id
  subnet_id      = aws_subnet.private-1c.id
}

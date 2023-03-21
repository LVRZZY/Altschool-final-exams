resource "aws_eip" "nat-gateway" {
  vpc = true

  tags = {
    Name = "nat-gateway"
  }
}

resource "aws_nat_gateway" "nat-gateway" {
  allocation_id = aws_eip.nat-gateway.id
  subnet_id     = aws_subnet.public-1a.id

  tags = {
    Name = "nat-gateway"
  }

  depends_on = [aws_internet_gateway.internet-gw]
}

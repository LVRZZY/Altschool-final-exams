resource "aws_internet_gateway" "internet-gw" {
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "internet-gw"
  }
}

#Task1 # create vpc 

resource "aws_vpc" "vpc-mk1" {
  cidr_block = "27.28.29.0/24"
  tags = {
    "Name" = "natwest-meraj-vpc"
  }
}
resource "aws_subnet" "mksn1" {
  vpc_id     = aws_vpc.vpc-mk1.id
  cidr_block = "27.28.29.0/25"
  tags = {
    "Name" = "natwest-vpc-mks1"
  }
}
resource "aws_subnet" "mksn2" {
  vpc_id     = aws_vpc.vpc-mk1.id
  cidr_block = "27.28.29.128/25"
  tags = {
    "Name" = "natwest-vpc-mks2"
  }
}

resource "aws_route_table" "mkrtb1" {
  vpc_id = aws_vpc.vpc-mk1.id
  tags = {
    "Name" = "Natwest-mk-Route-Table"
  }
}

resource "aws_internet_gateway" "mk-gw1" {
  vpc_id = aws_vpc.vpc-mk1.id
  tags = {
    Name = "mk-IG-Natwest"
  }
}

resource "aws_route_table_association" "rt1-mk-association1" {
  subnet_id      = aws_subnet.mksn1.id
  route_table_id = aws_route_table.mkrtb1.id

}
resource "aws_route_table_association" "rt1-mk-association2" {
  subnet_id      = aws_subnet.mksn2.id
  route_table_id = aws_route_table.mkrtb1.id

}
resource "aws_route" "mk-igroute" {
  # route_table_id            = data.aws_route_table.selected.id
  route_table_id         = aws_route_table.mkrtb1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.mk-gw1.id
}

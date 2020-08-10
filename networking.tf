resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet_a_public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    publicness = "public"
  }
}

resource "aws_subnet" "subnet_b_public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    publicness = "public"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_eip" "natgw_a_eip" {
  vpc = true
}

resource "aws_eip" "natgw_b_eip" {
  vpc = true
}

resource "aws_nat_gateway" "natgw_a" {
  allocation_id = aws_eip.natgw_a_eip.id
  subnet_id     = aws_subnet.subnet_a_public.id
  depends_on    = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "natgw_b" {
  allocation_id = aws_eip.natgw_b_eip.id
  subnet_id     = aws_subnet.subnet_b_public.id
  depends_on    = [aws_internet_gateway.igw]
}

resource "aws_subnet" "subnet_a_private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.101.0/24"
  availability_zone = "us-east-1a"
  tags = {
    publicness = "private"
  }
}

resource "aws_subnet" "subnet_b_private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.102.0/24"
  availability_zone = "us-east-1b"
  tags = {
    publicness = "private"
  }
}

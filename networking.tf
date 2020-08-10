resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# Enable internet access: Make internet gateway, route table, and associations
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

# *******************************************
# Public Subnets (on the internet)
# *******************************************

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

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Route table association with public subnets
resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.subnet_a_public.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.subnet_b_public.id
  route_table_id = aws_route_table.public_rt.id
}

# *******************************************
# Protected Subnets (behind a NAT gateway)
# *******************************************

resource "aws_subnet" "subnet_a_protected" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"
  tags = {
    publicness = "protected"
  }
}

resource "aws_subnet" "subnet_b_protected" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"
  tags = {
    publicness = "protected"
  }
}

resource "aws_nat_gateway" "natgw_a" {
  allocation_id = aws_eip.natgw_a_eip.id
  subnet_id     = aws_subnet.subnet_a_protected.id
  depends_on    = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "natgw_b" {
  allocation_id = aws_eip.natgw_b_eip.id
  subnet_id     = aws_subnet.subnet_b_protected.id
  depends_on    = [aws_internet_gateway.igw]
}

resource "aws_eip" "natgw_a_eip" {
  vpc = true
}

resource "aws_eip" "natgw_b_eip" {
  vpc = true
}

resource "aws_route_table" "protected_rt_a" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw_a.id
  }
}

resource "aws_route_table" "protected_rt_b" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw_b.id
  }
}

# Route table association with protected subnets
resource "aws_route_table_association" "protected_a" {
  subnet_id      = aws_subnet.subnet_a_protected.id
  route_table_id = aws_route_table.protected_rt_a.id
}

# Route table association with protected subnets
resource "aws_route_table_association" "protected_b" {
  subnet_id      = aws_subnet.subnet_b_protected.id
  route_table_id = aws_route_table.protected_rt_b.id
}

# *******************************************
# Private Subnets (no internet access)
# *******************************************

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

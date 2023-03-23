//subnet相關
resource "aws_vpc" "main"{
    cidr_block="10.0.0.0/16"
    tags={
        Name="quanna_vpc"
    }
}
resource "aws_subnet" "public1"{
    vpc_id = aws_vpc.main.id
    cidr_block="10.0.1.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
    tags={
        Name="quanna-public1"
    }
}
resource "aws_subnet" "public2"{
    vpc_id = aws_vpc.main.id
    cidr_block="10.0.2.0/24"
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = true
    tags={
        Name="quanna-public2"
    }
}
resource "aws_subnet" "private1"{
    vpc_id = aws_vpc.main.id
    cidr_block="10.0.3.0/24"
    availability_zone = "us-east-1a"
    tags={
        Name="quanna-private1"
    }
}
resource "aws_subnet" "private2"{
    vpc_id = aws_vpc.main.id
    cidr_block="10.0.4.0/24"
    availability_zone = "us-east-1b"
    tags={
        Name="quanna-private2"
    }
}
resource "aws_subnet" "private3"{
    vpc_id = aws_vpc.main.id
    cidr_block="10.0.5.0/24"
    availability_zone = "us-east-1a"
    tags={
        Name="quanna-private3"
    }
}
resource "aws_subnet" "private4"{
    vpc_id = aws_vpc.main.id
    cidr_block="10.0.6.0/24"
    availability_zone = "us-east-1b"
    tags={
        Name="quanna-private4"
    }
}
resource "aws_internet_gateway" "public_igw" {
  vpc_id = aws_vpc.main.id
}
resource "aws_eip" "forprivate" { //彈性ip
  vpc = true
  tags = {
    Name = "forprivate"
  }
}
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.forprivate.id
  subnet_id = aws_subnet.public2.id
}
//route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public_igw.id
  }
  tags = {
    Name = "1000-public"
  }
}
resource "aws_route_table" "privatec_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "1000-private"
  }
}

//把subnets一個個丟進route table裡面
resource "aws_route_table_association" "ptop1" {
  subnet_id = aws_subnet.public1.id
  //subnet_id  = aws_subnet.public2.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "ptop2" {
  //subnet_id  = aws_subnet.public1.id
  subnet_id  = aws_subnet.public2.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "ptop3" {
  //subnet_id  = aws_subnet.public1.id
  subnet_id  = aws_subnet.private1.id
  route_table_id = aws_route_table.privatec_rt.id
}
resource "aws_route_table_association" "ptop4" {
  //subnet_id  = aws_subnet.public1.id
  subnet_id  = aws_subnet.private2.id
  route_table_id = aws_route_table.privatec_rt.id
}
resource "aws_route_table_association" "ptop5" {
  //subnet_id  = aws_subnet.public1.id
  subnet_id  = aws_subnet.private3.id
  route_table_id = aws_route_table.privatec_rt.id
}
resource "aws_route_table_association" "ptop6" {
  //subnet_id  = aws_subnet.public1.id
  subnet_id  = aws_subnet.private4.id
  route_table_id = aws_route_table.privatec_rt.id
}

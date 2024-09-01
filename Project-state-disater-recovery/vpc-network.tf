
# create vpc
resource "aws_vpc" "day2-vpc" {
    cidr_block = "10.0.0.0/16"
  tags = {
    Name = "cust-vpc"
  }
}
# create internet gateway
resource "aws_internet_gateway" "day2-ig" {
    vpc_id = aws_vpc.day2-vpc.id
    tags = {
    Name = "cust-ig"
  }
}

# create subnet 1
resource "aws_subnet" "day2-sub1" {
    vpc_id = aws_vpc.day2-vpc.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = true  # for auto asign public ip for subnet
    tags = {
    Name = "cust-sub1"
  }
}
# create subnet 2
resource "aws_subnet" "day2-sub2" {
  vpc_id = aws_vpc.day2-vpc.id
  availability_zone = "us-east-1a"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true  # for auto asign public ip for subnet
  tags = {
    Name = "cust-sub2"
  }
}
 # create route table and attch ig
 resource "aws_route_table" "day2-rt" {
    vpc_id = aws_vpc.day2-vpc.id
    tags = {
    Name = "cust-rt"
        }
  # route table edit route and attach ig
    route  {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.day2-ig.id

    }
    
}

#asociate subnet1 to route table
resource "aws_route_table_association" "day2-rt-sub1" {
    route_table_id = aws_route_table.day2-rt.id
    subnet_id = aws_subnet.day2-sub1.id
  
  
}
#asociate subnet2 to route table
resource "aws_route_table_association" "day2-rt-sub2" {
  route_table_id = aws_route_table.day2-rt.id
  subnet_id = aws_subnet.day2-sub2.id
}
# # create a nat gateway
# resource "aws_eip" "elasticip" {

# }
# resource "aws_nat_gateway" "cust-nat" {
#   subnet_id = aws_subnet.day2-sub1.id
#   connectivity_type = "public"
#   allocation_id = aws_eip.elasticip.id
#   tags = {
#     Name = "natgateway"
#   }
  
# }
# #create prvt routetable and attach to nat gateway
# resource "aws_route_table" "cust-prvt" {
#   vpc_id = aws_vpc.day2-vpc.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_nat_gateway.cust-nat.id
#   }
  
# }
# ## create prvt subnet
# resource "aws_subnet" "pvt-sub" {
#   cidr_block = "10.0.2.0/24"
#   vpc_id = aws_vpc.day2-vpc.id
# }
# # prvt route table association
# resource "aws_route_table_association" "prvt-rt" {
#   route_table_id = aws_route_table.cust-prvt.id
#   subnet_id = aws_subnet.pvt-sub.id
# }
# create security group
resource "aws_security_group" "cust-sg" {
    vpc_id = aws_vpc.day2-vpc.id
    tags = {
    Name = "cust-sg"
  }
  ingress {
    description = "http for sg"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "ssh for sg"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  egress {
    description = "outbond of sg"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}








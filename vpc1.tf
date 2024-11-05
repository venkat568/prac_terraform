resource "aws_vpc" "dev" {
    cidr_block = var.cidr_block
    enable_dns_hostnames = true
tags = {
  "Name" = "${var.vpc_name}"
}
  
}


resource "aws_internet_gateway" "testigw" {

  vpc_id = aws_vpc.dev.id
  tags = {
    "Name" = "${var.vpc_name}-igw"
  }
}

resource "aws_subnet" "public1" {
  count=2
  
  vpc_id                  = aws_vpc.dev.id
  cidr_block              = element(var.public1_cidr_block,count.index)
  availability_zone       = element(var.azs,count.index)
  map_public_ip_on_launch = true
  tags = {
    "Name" = "${var.vpc_name}-public${count.index+1}"
  }
}



resource "aws_route_table" "rt" {
   vpc_id = aws_vpc.dev.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.testigw.id
    
  }
  tags = {
    "Name" = "${var.vpc_name}-rt"
  }
}

resource "aws_route_table_association" "publicsubnet1" {
  count=2

  subnet_id      = element(aws_subnet.public1.*.id,count.index)
  route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "test-sg" {
  vpc_id      = aws_vpc.dev.id
  name        = "allow all rules"
  description = "allow inbound and outbound rules"
  tags = {
    "Name" = "${var.vpc_name}-sg"
  }
  ingress {
    description = "allow all rules"
    to_port     = 0
    from_port   = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "allow all rules"
    to_port     = 0
    from_port   = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "test-instance" {
count =1
  ami                         = "ami-0866a3c8686eaeeba"
  key_name                    = "venki"
  instance_type               = "t2.micro"
  vpc_security_group_ids =  [aws_security_group.test-sg.id]
  subnet_id                   = aws_subnet.public1[0].id
  availability_zone           = "us-east-1a"
  private_ip = "10.40.1.5"
  associate_public_ip_address = true
  tags = {
    "Name" = "${var.vpc_name}-server"
  }

}


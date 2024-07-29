# create instance 

resource "aws_instance" "dev" {
    ami = var.ami
    instance_type = var.instance_type
    subnet_id = aws_subnet.dev.id
    key_name = var.key_name
    tags = {
      Name = "dev-ec2"
    }
}




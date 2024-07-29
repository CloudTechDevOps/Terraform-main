provider "aws" {
  
}
resource "aws_instance" "test" {
    ami = "ami-0440d3b780d96b29d"
    instance_type = "t2.micro"
    user_data= file("test.sh")
}
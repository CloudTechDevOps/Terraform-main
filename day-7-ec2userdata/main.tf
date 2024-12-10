provider "aws" {
  
}
resource "aws_instance" "test" {
    ami = "ami-02141377eee7defb9"
    instance_type = "t2.micro"
    user_data= file("test.sh")
}

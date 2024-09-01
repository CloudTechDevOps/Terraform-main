resource "aws_instance" "test" {
    ami = "ami-0ae8f15ae66fe8cda"
    instance_type = "t2.nano"
    availability_zone = "us-east-1a"
    key_name = "awsaws"
}
resource "aws_instance" "name" {
    ami = "ami-013e83f579886baeb"
    instance_type = "t2.micro"
    key_name = "jenkin"

    tags = {
      Name = "newtag"
    }
  
}

resource "aws_s3_bucket" "name" {
    bucket = "qwertyuasdfghnjm"
  
}
#terraform apply -target=aws_s3_bucket.name #apply or destroy particular resource
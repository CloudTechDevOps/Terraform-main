 #creating s3 bucket and dynamo DB for state backend storgae and applying the lock mechanisam for statefile

provider "aws" { 
    region = "us-east-1"
}



resource "aws_s3_bucket" "example" {
  bucket = "qwertyuiopasdfg"
  
}



resource "aws_instance" "dev" {
    ami = "ami-0440d3b780d96b29d"
    instance_type = "t2.micro"
    depends_on = [ aws_s3_bucket.example]
}



 
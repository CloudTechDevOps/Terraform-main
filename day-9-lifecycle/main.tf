resource "aws_instance" "test" {
    ami = "ami-0440d3b780d96b29d"
    instance_type = "t2.micro"
    availability_zone = "us-east-1e"
    subnet_id = "subnet-0a509e41d91a981ec"
    key_name = "test"
    
  tags = {
    Name = "test"
  }

#below examples are for lifecycle meta_arguments 

#   lifecycle {
#     create_before_destroy = true    #this attribute will create the new object first and then destroy the old one
#   }

# lifecycle {
#   prevent_destroy = true    #Terraform will error when it attempts to destroy a resource when this is set to true:
# }


  lifecycle {
    ignore_changes = [tags,] #This means that Terraform will never update the object but will be able to create or destroy it.
  }
}
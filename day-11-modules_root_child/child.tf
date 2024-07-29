module "test" {
    source = "./modules/ec2" 
    ami       	= "ami-0440d3b780d96b29d"
    instance_type = "t2.micro"
    subnet_id 	= "subnet-0f2a81412b51a8ae0"
    key_name  	= "testlt"
    name        = "test_ec2"
}
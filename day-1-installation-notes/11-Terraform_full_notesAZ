---------------------------------------------------------------------------------------------------------
                                         #### Terrafrom ###
-------------------------------------------------------------------------------------------------------

### What Is Terraform? 
Terraform is an IAC tool, used primarily by DevOps teams to automate various infrastructure tasks. The provisioning of cloud resources, for instance, is one of the main use cases of Terraform. It’s a cloud-agnostic, open-source provisioning tool written in the Go language and created by HashiCorp.

Terraform allows you to describe your complete infrastructure in the form of code. Even if your servers come from different providers such as AWS or Azure, Terraform helps you build and manage these resources in parallel across providers. Think of Terraform as connective tissue and common language that you can utilize to manage your entire IT stack.


###--- Benefits of Infrastructure-as-Code (IaC) ---###

IaC replaces standard operating procedures and manual effort required for IT resource management with lines of code. Instead of manually configuring cloud nodes or physical hardware, IaC automates the process infrastructure management through source code.

Here are several of the major key benefits of using an IaC solution like Terraform:

Speed and Simplicity. IaC eliminates manual processes, thereby accelerating the delivery and management lifecycles. IaC makes it possible to spin up an entire infrastructure architecture by simply running a script.
Team Collaboration. Various team members can collaborate on IaC software in the same way they would with regular application code through tools like Github. Code can be easily linked to issue tracking systems for future use and reference.
Error Reduction. IaC minimizes the probability of errors or deviations when provisioning your infrastructure. The code completely standardizes your setup, allowing applications to run smoothly and error-free without the constant need for admin oversight.
Disaster Recovery. With IaC you can actually recover from disasters more rapidly. Because manually constructed infrastructure needs to be manually rebuilt. But with IaC, you can usually just re-run scripts and have the exact same software provisioned again.
Enhanced Security. IaC relies on automation that removes many security risks associated with human error. When an IaC-based solution is installed correctly, the overall security of your computing architecture and associated data improves massively.


------ ### Basic Terraform folder structure ### ------

projectname/
    |
    |-- provider.tf
    |-- version.tf
    |-- backend.tf
    |-- main.tf
    |-- variables.tf
    |-- terraform.tfvars
    |-- outputs.tf

Give Terraform files logical names
Terraform tutorials online often demonstrate a directory structure consisting of three files: 

main.tf:    contains all providers, resources and data sources
variables.tf: contains all defined variables
output.tf:    contains all output resources
The issue     with this structure is that most logic is stored in the single main.tf file which therefore becomes pretty complex and long. Terraform, however, does not mandate this structure, it only requires a directory of Terraform files. Since the filenames do not matter to Terraform I propose to use a structure that enables users to quickly understand the code. Personally I prefer the following structure 
provider.tf: contains the terraform block and provider block
data.tf: contains all data sources
variables.tf: contains all defined variables
locals.tf: contains all local variables
output.tf: contains all output resources

---------- ##### Importent Terraform Commands ### --------
### Version

terraform –version	Shows terraform version installed

### Initialize infrastructure ###

terraform init	                :Initialize a working directory
terraform init -input=true	:Ask for input if necessary
terraform init -lock=false	:Disable locking of state files during state-related operations

terraform plan	                :Creates an execution plan (dry run)
terraform apply	                :Executes changes to the actual environment
terraform apply –auto-approve	:Apply changes without being prompted to enter ”yes”
terraform destroy –auto-approve :Destroy/cleanup without being prompted to enter ”yes”

Terraform Workspaces
terraform workspace new	Create a new workspace and select it
terraform workspace select	Select an existing workspace
terraform workspace list	List the existing workspaces
terraform workspace show	Show the name of the current workspace
terraform workspace delete	Delete an empty workspace


Terraform Import
terraform import aws_instance.example i-abcd1234(instance id)	#import an AWS instance with ID i-abcd1234 into aws_instance resource named “foo”


---## Statefile ##--:
## What is state and why is it important in Terraform? #########
“Terraform must store state about your managed infrastructure and configuration. This state is used by Terraform to map real world resources to your configuration, keep track of metadata, and to improve performance for large infrastructures. This state file is extremely important; it maps various resource metadata to actual resource IDs so that Terraform knows what it is managing. This file must be saved and distributed to anyone who might run Terraform.”

Remote State:
“By default, Terraform stores state locally in a file named terraform.tfstate. When working with Terraform in a team, use of a local file makes Terraform usage complicated because each user must make sure they always have the latest state data before running Terraform and make sure that nobody else runs Terraform at the same time.”

“With remote state, Terraform writes the state data to a remote data store, which can then be shared between all members of a team.”

State Lock:
“If supported by your backend, Terraform will lock your state for all operations that could write state. This prevents others from acquiring the lock and potentially corrupting your state.”

“State locking happens automatically on all operations that could write state. You won’t see any message that it is happening. If state locking fails, Terraform will not continue. You can disable state locking for most commands with the -lock flag but it is not recommended.”

## Setting up our S3 Backend 
Create a new file in your working directory labeled Backend.tf

Copy and paste this configuration in your source code editor in your backend.tf file.

    terraform {
      backend "s3" {
        encrypt = true    
         bucket = "sample"
        dynamodb_table = "terraform-state-lock-dynamo"
        key    = "terraform.tfstate"
        region = "us-east-1"
      }
    }



## before that we have to create resource are s3 and dynamodb those resource will call in backend.tf
## Creating our DynamoDB Table 
Create a new file in your working directory labeled dynamo.tf

Copy and paste this configuration in your source code editor in your main.tf file.

# S3 
resource "aws_s3_bucket" "example" {
  bucket = sample
}


#Dynamodb
    resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
      name = "terraform-state-lock-dynamo"
      hash_key = "LockID"
      read_capacity = 20
      write_capacity = 20
     
      attribute {
        name = "LockID"
        type = "S"
      }
    }
   
 ## --- DATA source ##----- 

What is Data Source?
Data source in terraform relates to resources but only it gives the information about an object rather than creating one. It provides dynamic information about the entities we define outside of terraform.
Data Sources allow fetching data about the infrastructure components’ configuration. It allows to fetch data from the cloud provider APIs using terraform scripts.
When we refer to a resource using a data source, it won’t create the resource. Instead, they get information about that resource so that we can use it in further configuration if required.

How to use Data Source?
For example, we will create an ec2 instance using a vpc and subnet, both of which are created on aws console that is external to terraform configuration.

Step 1: Create a terraform directory and create a file named provider.tf in it. Below code represents the details of the aws provider that we’re using, like its region, access key and secret key.

provider "aws"{
  region     = "us-east-1"
  access_key = "your_access_key"
  secret_key = "your_secret_key" #keys no  need to configure here it will call from .aws folder from local
}
Step 2: In that directory, create another file named demo_datasource.tf and use the code given below.


data "aws_vpc" "vpc" {
  id = vpc_id
}


data "aws_subnet" "subnet" {
  id = subnet_id
}

resource "aws_security_group" "sg" {  # here we are creating security grop by calling exicting vpc so we can use data source block
  name = "sg"
  vpc_id = data.aws_vpc.vpc.id
 ingress                = [
   {
     cidr_blocks      = [ "0.0.0.0/0"]
     description      = ""
     from_port        = 22
     protocol         = "tcp"
     security_groups  = []
     self             = false
     to_port          = 22
  }
  ]
  egress = [
    {
      cidr_blocks      = [ "0.0.0.0/0"]
      description      = ""
      from_port        = 0
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
}

resource "aws_instance" "dev" {
    ami = data.aws_ami.amzlinux.id
    instance_type = "t2.micro"
    subnet_id = data.aws_subnet.dev.id
    security_groups = [ data.aws_security_group.dev.id ]
tags = {
    Name = "DataSource- Instance"
  }
}
In the above block of code, we are using a vpc and a subnet that is already created on AWS using its console. Then using data block, which refers to data sources, that is, a vpc and a subnet. By doing this, we are retrieving the information about the vpc and subnet that are created outside of terraform configuration. Then creating a security group that uses vpc_id that was fetched using data block. Further creating the EC2 instance that uses the subnet_id that was also fetched using data block.
So, in this example, data source is being used to get data about the vpc and subnet that were not created using terraform script and using this data further for creating an EC2.


  case-2
  we can call AMI id also by using data source block 

  data "aws_ami" "amzlinux" {
  most_recent = true
  owners = [ "amazon" ]
  filter {
    name = "name"
    values = [ "amzn2-ami-hvm-*-gp2" ]
  }
  filter {
    name = "root-device-type"
    values = [ "ebs" ]
  }
  filter {
    name = "virtualization-type"
    values = [ "hvm" ]
  }
  filter {
    name = "architecture"
    values = [ "x86_64" ]
  }
}



 ------------ #### Terraform Import ####-----------------------------

Why Terraform Impoert?
Terraform is a relatively new technology and adopting it to manage an organisation’s cloud resources might take some time and effort. The lack of human resources and the steep learning curve involved in using Terraform effectively causes teams to start using cloud infrastructure directly via their respective web consoles.

For that matter, any kind of IaC method (CloudFormation, Azure ARM templates, Pulumi, etc.) requires some training and real-time scenario handling experience. Things get especially complicated when dealing with concepts like states and remote backends. In a worst case scenario, you can lose the terraform.tfstate file. Luckily, you can use the import functionality to rebuild it.

Getting the pre-existing cloud resources under the Terraform management is facilitated by Terraform import. import is a Terraform CLI command which is used to read real-world infrastructure and update the state, so that future updates to the same set of infrastructure can be applied via IaC.

The import functionality helps update the state locally and it does not create the corresponding configuration automatically. However, the Terraform team is working hard to improve this function in upcoming releases.

Simple Import
With an understanding of why we need to import cloud resources, let us begin by importing a simple resource – EC2 instance in AWS. I am assuming the Terraform installation and configuration of AWS credentials in AWS CLI is already done locally. We will not go into the details of that in this tutorial. To import a simple resource into Terraform, follow the below step-by-step guide. 

1. Prepare the EC2 Instance
Assuming the Terraform installation and configuration of AWS credentials in AWS CLI is already done locally, begin by importing a simple resource—EC2 instance in AWS. For the sake of this tutorial, we will create an EC2 resource manually to be imported. This could be an optional step if you already have a target resource to be imported.

Terraform: Create EC2 Instance in Existing VPC
Go ahead and provision an EC2 instance in your AWS account. Here are the example details of the EC2 instance thus created:

Name: MyVM
Instance ID: i-0b9be609418aa0609
Type: t2.micro
VPC ID: vpc-1827ff72
…

2. Create main.tf and Set Provider Configuration
The aim of this step is to import this EC2 instance into our Terraform configuration. In your desired path, create `main.tf` and configure the AWS provider. The file should look like the one below.

Importing EC2 Instance into Terraform Configuration: Example
// Provider configuration
terraform {
 required_providers {
   aws = {
     source  = "hashicorp/aws"
     version = "~> 3.0"
   }
 }
}
 
provider "aws" {
 region = "us-east-1"
}
Run terraform init to initialize the Terraform modules. Below is the output of a successful initialization.

Initializing the backend...

Initializing provider plugins...
- Finding hashicorp/aws versions matching "~> 3.0"...
- Installing hashicorp/aws v3.51.0...
- Installed hashicorp/aws v3.51.0 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.

3. Write Config for Resource To Be Imported
As discussed earlier, Terraform import does not generate the configuration files by itself. Thus, you need to create the corresponding configuration for the EC2 instance manually. This doesn’t need many arguments as we will have to add or modify them when we import the EC2 instance into our state file.

However, if you don’t mind not seeing colorful output on CLI, you can begin adding all the arguments you know. But this is not a foolproof approach, because normally the infrastructure you may have to import will not have been created by you. So it is best to skip a few arguments anyway.

In a moment we will take a look at how to adjust our configuration to reflect the exact resource. For now, append the main.tf file with EC2 config. For example, I have used the below config. The only reason I have included ami and instance_type attribute, is that they are the required arguments for aws_instance resource block.

resource "aws_instance" "myvm" {
 ami           = "unknown"(we need to add from state file reference)
 instance_type = "unknown"(we need to add from state file reference)
}
4. Import
Think of it as if the cloud resource (EC2 instance) and its corresponding configuration were available in our files. All that’s left to do is to map the two into our state file. We do that by running the import command as follows.

import command:

terraform import aws_instance.myvm <Instance ID>
A successful output should look like this:

aws_instance.myvm: Importing from ID "i-0b9be609418aa0609"...
aws_instance.myvm: Import prepared!
  Prepared aws_instance for import
aws_instance.myvm: Refreshing state... [id=i-0b9be609418aa0609]

Import successful!

The resources that were imported are shown above. These resources are now in
your Terraform state and will henceforth be managed by Terraform.
The above command maps the aws_instance.myvm configuration to the EC2 instance using the ID. By mapping I mean that the state file now “knows” the existence of the EC2 instance with the given ID. The state file also contains information about each attribute of this EC2 instance, as it has fetched the same using the import command.

5. Observe State Files and Plan Output
Please notice that the directory now also contains terraform.tfstate file. This file was generated after the import command was successfully run. Take a moment to go through the contents of this file.

Right now our configuration does not reflect all the attributes. Any attempt to plan/apply this configuration will fail because we have not adjusted the values of its attributes. To close the gap in configuration files and state files, run terraform plan and observe the output.

.
.
.
          } -> (known after apply)
          ~ throughput            = 0 -> (known after apply)
          ~ volume_id             = "vol-0fa93084426be508a" -> (known after apply)
          ~ volume_size           = 8 -> (known after apply)
          ~ volume_type           = "gp2" -> (known after apply)
        }

      - timeouts {}
    }

Plan: 1 to add, 0 to change, 1 to destroy.

───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply"
now.
The plan indicates that it would attempt to replace the EC2 instance. But this goes completely against our purpose. We could do it anyway by simply not caring about the existing resources, and creating new resources using configuration.

The good news is that Terraform has taken note of the existence of an EC2 instance that is associated with its state. 

6. Improve Config To Avoid Replacement
At this point, it is important to understand that the terraform.tfstate file is a vital piece of reference for Terraform. All of its future operations are performed with consideration for this state file. You need to investigate the state file and update your configuration accordingly so that there is a minimum difference between them.

The use of the word “minimum” is intentional here. Right now, you need to focus on not replacing the given EC2 instance, but rather aligning the configuration so that the replacement can be avoided. Eventually, you would achieve a state of 0 difference.

Observe the plan output, and find all those attributes which cause the replacement. The plan output will highlight the same. In our example, the only attribute that causes replacement is the AMI ID. Closing this gap should avoid the replacement of the EC2 instance.

Change the value of ami from “unknown” to what is highlighted in the plan output, and run terraform plan again. Notice the output.

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  ~ update in-place

Terraform will perform the following actions:

  # aws_instance.myvm will be updated in-place
  ~ resource "aws_instance" "myvm" {
        id                                   = "i-0b9be609418aa0609"
      ~ instance_type                        = "t2.micro" -> "unknown"
      ~ tags                                 = {
          - "Name" = "MyVM" -> null
        }
      ~ tags_all                             = {
          - "Name" = "MyVM"
        } -> (known after apply)
        # (27 unchanged attributes hidden)






        # (6 unchanged blocks hidden)
    }

Plan: 0 to add, 1 to change, 0 to destroy.
This time the plan does not indicate the replacement of the EC2 instance. If you get the same output, you are successful in partially importing our cloud resource. You are currently in a state of lowered risk—if we apply the configuration now, the resource will not be replaced, but a few attributes would change.



5 Ways to Manage Terraform at Scale
How to Automate Terraform Deployments and Infrastructure Provisioning
Why DevOps Engineers Recommend Spacelift
7. Improve Config To Avoid Changes
If we want to achieve a state of 0 difference, you need to align your resource block even more. The plan output highlights the attribute changes using ~ sign. It also indicates the difference in the values. For example, it highlights the change in the instance_type value from “t2.micro” to “unknown”.

In other words, if the value of instance_type had been “t2.micro”, Terraform would NOT have asked for a change. Similarly, you can see there are changes to the tags highlighted as well. Let’s change the configuration accordingly so that we close these gaps. The final aws_instance resource block should look as follows:

resource "aws_instance" "myvm" {
 ami           = "ami-00f22f6155d6d92c5"
 instance_type = "t2.micro"
 
 tags = {
     "Name": "MyVM"
 }
}
Run terraform plan again, and observe the output.

aws_instance.myvm: Refreshing state... [id=i-0b9be609418aa0609]

No changes. Your infrastructure matches the configuration.

Terraform has compared your real infrastructure against your configuration and found no differences, so no changes are needed.
If you have the same output, congratulations, as you have successfully imported a cloud resource into your Terraform config. It is now possible to manage this configuration via Terraform directly, without any surprises.




  




--------## Meta-arguments ##--------------

Meta-arguments in Terraform are special arguments that can be used with resource blocks and modules to control their behavior or influence the infrastructure provisioning process. They provide additional configuration options beyond the regular resource-specific arguments.

Meta-Arguments in Terraform are as follows:

depends_on:    Specifies dependencies between resources. It ensures that one resource is created or updated before another resource.
count:         Controls resource instantiation by setting the number of instances created based on a given condition or variable.
for_each:      Allows creating multiple instances of a resource based on a map or set of strings. Each instance is created with its unique key-value pair.
lifecycle:     Defines lifecycle rules for managing resource updates, replacements, and deletions.
provider:      Specifies the provider configuration for a resource. It allows selecting a specific provider or version for a resource.
provisioner:   Specifies actions to be taken on a resource after creation, such as running scripts or executing commands.
connection:    Defines the connection details to a resource, enabling remote execution or file transfers.
variable:      Declares input variables that can be provided during Terraform execution.
output:        Declares output values that can be displayed after Terraform execution.
locals:        Defines local values that can be used within the configuration files.

-----------------------------------------------------------------------
                ### depends_on ###
------------------------------------------------------------------------
Terraform has a feature of identifying resource dependency. This means that Terraform internally knows the sequence in which the dependent resources needs to be created whereas the independent resources are created parallelly.

But in some scenarios, some dependencies are there that cannot be automatically inferred by Terraform. In these scenarios, a resource relies on some other resource’s behaviour but it doesn’t access any of the resource’s data in arguments.
For those dependencies, we’ll use depends_on meta-argument to explicitly define the dependency.

depends_on meta-argument must be a list of references to other resources in the same calling resource.

This argument is specified in resources as well as in modules (Terraform version 0.13+)

Example-1


#

provider "aws" { 
}

resource "aws_s3_bucket" "example" {
  bucket = "qwertyuiopasdfg"
  
}



resource "aws_instance" "dev" {
   ami = "ami-0440d3b780d96b29d"
   instance_type = "t2.micro"
   depends_on = [ aws_s3_bucket.example] # here depends-on block will help after cration of s3 only ec2 will create if creation of s3 fails ec2 will not create 
}



 

Example-2
### Create IAM policy
resource "aws_iam_policy" "example_policy" {
  name        = "example_policy"
  description = "Permissions for EC2"
  policy      = jsonencode({
    Version: "2012-10-17",
    Statement: [
        {
            Action: "ec2:*",
            Effect: "Allow",
            Resource: "*"
        }
      ]
    })
}

### Create IAM role
resource "aws_iam_role" "example_role" {
  name = "example_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "examplerole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

### Attach IAM policy to IAM role
resource "aws_iam_policy_attachment" "policy_attach" {
  name       = "example_policy_attachment"
  roles      = [aws_iam_role.example_role.name]
  policy_arn = aws_iam_policy.example_policy.arn
}

### Create instance profile using role
resource "aws_iam_instance_profile" "example_profile" {
  name = "example_profile"
  role = aws_iam_role.example_role.name
}

### Create EC2 instance and attache IAM role
resource "aws_instance" "example_instance" {
  instance_type        = var.ec2_instance_type
  ami                  = var.image_id
  iam_instance_profile = aws_iam_instance_profile.example_profile.name
  depends_on = [ aws_iam_role.example_role ] # heare after creating iam role only, ec2 will create and role attach to ec2 

}
--------------------------------------------------
                 ### count ###
----------------------------------------------------
In Terraform, a resource block actually configures only one infrastructure object by default. If we want multiple resources with same configurations, we can define the count meta-argument. This will reduce the overhead of duplicating the resource block that number of times.

count require a whole number and will then create that resource that number of times. To identify each of them, we use the count.index which is the index number corresponds to each resource. The index ranges from 0 to count-1.

This argument is specified in resources as well as in modules (Terraform version 0.13+). Also, count meta-argument cannot be used with for_each.

example:1

resource "aws_instance" "myec2" {
    ami = "ami-0230bd60aa48260c6"
    instance_type = "t2.micro"
    count = 2
    tags = {
    #   Name = "webec2"
      Name = "webec2-${count.index}"
    }
}



example:2

variable "ami" {
  type    = string
  default = "ami-0440d3b780d96b29d"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "sandboxes" {
  type    = list(string)
  default = [ "sandbox_server_two", "sandbox_server_three"]
}

# main.tf
resource "aws_instance" "sandbox" {
  ami           = var.ami
  instance_type = var.instance_type
  count         = length(var.sandboxes)

  tags = {
    Name = var.sandboxes[count.index]
  }
}



-------------------## for_each ##------------------------------------

As specified in the count meta-argument, that the default behaviour of a resource is to create a single infrastructure object which can be overridden by using count, but there is one more flexible way of doing the same which is by using for_each meta argument.

The for_each meta argument accepts a map or set of strings. Terraform will create one instance of that resource for each member of that map or set. To identify each member of the for_each block, we have 2 objects:

each.key: The map key or set member corresponding to each member.
each.value: The map value corresponding to each member.
This argument is specified in resources (Terraform version 0.12.6) as well as in modules (Terraform version 0.13+)

## Example for_each

# variables.tf
variable "ami" {
  type    = string
  default = "ami-0078ef784b6fa1ba4"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "sandboxes" {
  type    = set(string)
  default = ["sandbox_one", "sandbox_two", "sandbox_three"]
}

# main.tf
resource "aws_instance" "sandbox" {
  ami           = var.ami
  instance_type = var.instance_type
  for_each      = var.sandboxes
  tags = {
    Name = each.value # for a set, each.value and each.key is the same
  }
}







------------------------------------------------------------------
                       ### multi provider ###
-----------------------------------------------------------------
provider meta-argument specifies which provider to be used for a resource. This is useful when you are using multiple providers which is usually used when you are creating multi-region resources. For differentiating those providers, you use an alias field.
The resource then reference the same alias field of the provider as provider.alias to tell which one to use.

Ex:
# Provider-1 for us-east-1 (Default Provider)
provider "aws" {
  region = "ap-south-1"
}

#Another provider alias 
provider "aws" {
  region = "us-east-1"
  alias = "america"
}

resource "aws_s3_bucket" "test" {
  bucket = "del-hyd-naresh-it"

}
resource "aws_s3_bucket" "test2" {
  bucket = "del-hyd-naresh-it-test2"
  provider = aws.america
  
}


--------------## Lifecycycle ##----------------------------------

What is Terraform Lifecycle Meta-Argument?

The Terraform lifecycle is a nested configuration block within a resource block.  The lifecycle meta-argument can be used to specify how Terraform should handle the creation, modification, and destruction of resources. Meta-arguments are arguments used in resource blocks.

Terraform Lifecycle Meta-Argument Example
he lifecycle meta-argument can be used within any resource block like so:

Ex:resource "aws_instance" "test" {
    ami = "ami-0440d3b780d96b29d"
    instance_type = "t2.micro"
    availability_zone = "us-east-1b"
    
  tags = {
    Name = "test"
  }

  lifecycle {
    create_before_destroy = true    #this attribute will create the new object first and then destroy the old one
  }

# lifecycle {
#   prevent_destroy = true    #Terraform will error when it attempts to destroy a resource when this is set to true:
# }


#   lifecycle {
#     ignore_changes = [tags,] #This means that Terraform will never update the object but will be able to create or destroy it.
#   }
}


Managing the Resource Lifecycle Using the Lifecycle Meta-Argument
Controlling the flow of Terraform operations is possible using the lifecycle meta-argument. This is useful in scenarios when you need to protect items from getting changed or destroyed.

A common scenario that requires the use of a lifecycle meta-argument occurs when the Terraform provider itself does not handle a change correctly and so can be safely ignored, rather than the provider attempting to update an object necessarily. With the provider version updates, these “bugs” are slowly ironed out, at which point the lifecycle meta-argument can be removed from the resource.

There are several attributes available for use with the lifecycle meta-argument:

create_before_destroy
When Terraform determines it needs to destroy an object and recreate it, the normal behavior will create the new object after the existing one is destroyed. Using this attribute will create the new object first and then destroy the old one. This can help reduce downtime. Some objects have restrictions that the use of this setting may cause issues with, preventing objects from existing concurrently. Hence, it is important to understand any resource constraints before using this option.


lifecycle {
  create_before_destroy = true
}
prevent_destroy
This lifecycle option prevents Terraform from accidentally removing critical resources. This is useful to avoid downtime when a change would result in the destruction and recreation of resource. This block should be used only when necessary as it will make certain configuration changes impossible.

lifecycle {
  prevent_destroy = true
}

Terraform will error when it attempts to destroy a resource when this is set to true:

Error: Instance cannot be destroyed
resource details...
Resource [resource_name] has lifecycle.prevent_destroy set, but the plan calls for this resource to be destroyed. To avoid this error and continue with the plan, either disable lifecycle.prevent_destroy or reduce the scope of the plan using the -target flag.
ignore_changes
The Terraform ignore_changes lifecycle option can be useful when attributes of a resource are updated outside of Terraform.

It can be used, for example, when an Azure Policy automatically applies tags. When Terraform detects the changes the Azure Policy has applied, it will ignore them and not attempt to modify the tag. Attributes of the resource that need to be ignored can be specified.

In the example below, the department tag will be ignored:

lifecycle {
  ignore_changes = [
    tags["department"]
  ]
}

If all attributes are to be ignored, then the all keyword can be used. This means that Terraform will never update the object but will be able to create or destroy it.

lifecycle {
  ignore_changes = [
    all
  ]
}


------------------------## Locals ####################

A local value assigns a name to an expressions so you can use the name multiple times within a module. It is helpful to avoid repeating the same values or expressions multiple times in a configuration, but if overused they can also make a configuration hard to read . Locals values are not set by the user input or values in terraform files, instead, they are set ‘locally’ to the configuration .

Ex:

locals {
  bucket-name = "${var.layer}-${var.env}-bucket-hydnaresh"
}

resource "aws_s3_bucket" "demo" {
    # bucket = "web-dev-bucket"
    # bucket = "${var.layer}-${var.env}-bucket-hyd"
    bucket = local.bucket-name
    tags = {
        # Name = "${var.layer}-${var.env}-bucket-hyd"
        Name = local.bucket-name
        Environment = var.env
    }
    

  
}

------ ### Provisioners ### --------------

Terraform includes the concept of provisioners as a measure of pragmatism, knowing that there will always be certain behaviors that can’t be directly represented in Terraform’s declarative model.

Provisioners can be used to model specific actions on the local machine or on a remote machine in order to prepare servers or other infrastructure objects for service.
File Provisioner:
The file provisioner is used to copy files or directories from the machine executing the terraform apply to the newly created resource.  The file provisioner can connect to the resource using either ssh or winrm connections.

The file provisioner can upload a complete directory to the remote machine.

resource "aws_instance" "web" {
  # ...

  # Copies the myapp.conf file to /etc/myapp.conf
  provisioner "file" {
    source      = "conf/myapp.conf"
    destination = "/etc/myapp.conf"
  }

  
}
local-exec Provisioner:
The local-exec provisioner invokes a local executable after a resource is created. This invokes a process on the machine running Terraform, not on the resource.

Basically, this provisioner is used when you want to perform some tasks onto your local machine where you have installed the terraform. So local-exec provisioner is never used to perform any task on the remote machine. It will always be used to perform local operations onto your local machine.

resource "aws_instance" "web" {
  # ...

  provisioner "local-exec" {
    command = "echo ${self.private_ip} >> private_ips.txt"
  }
}
remote-exec Provisioner:
As the name suggests remote-exec provisioner is always going to work on the remote machine. With the help of this, you can specify the commands of shell scripts that want to execute on the remote machine. The remote-exec provisioner invokes a script on a remote resource after it is created. This can be used to run a configuration management tool, bootstrap into a cluster, etc. It requires a connection and supports both ssh and winrm.

resource "aws_instance" "web" {
  # ...

  # Establishes connection to be used by all
  # generic remote provisioners (i.e. file/remote-exec)
  connection {
    type        = "ssh"
    user        = "ubuntu"  # Replace with the appropriate username for your EC2 instance
    # private_key = file("C:/Users/veerababu/.ssh/id_rsa")
    private_key = file("~/.ssh/id_rsa")  #private key path
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
"touch file200",
"echo hello from aws >> file200",
]
 }
}
It can be used inside the Terraform resource object and in that case, it will be invoked once the resource is created, or it can be used inside a null resource which is my preferred approach as it separates this non-terraform behavior from the real terraform behavior.




------------------------------------ ## Modules ##------------------------------------------
What is module?

What are Terraform Modules?
Terraform modules are reusable and encapsulated collections of Terraform configurations. They simplify managing resources, making your Terraform code more manageable and scalable. Modules make defining, configuring, and organizing resources modular and consistent while abstracting away their complexity to make Terraform code more scalable and maintainable.

Benefits of Using Terraform Modules
Using Terraform modules brings several advantages to your infrastructure provisioning process:

Reusability: Modules allow you to organize infrastructure resources and configurations into containers you can repurpose across projects and environments. This reuse saves effort and reduces errors significantly.

Abstraction: Modules simplify resource creation and configuration processes for Terraform configuration files, making them more concise and understandable.

Encapsulation: Modules isolate resources and their dependencies, making it more straightforward for you to manage or modify individual pieces of your infrastructure without impacting others or hindering modularity in its codebase. This improves its modularity.

Versioning: Terraform modules can be versioned, making it easier to track changes and update dependencies in an orderly manner. This ensures that changes made do not cause unintended problems in your infrastructure.

Collaboration: Modules allow your team and the wider community to work more collaboratively by sharing them via Terraform Registry or private module repositories - encouraging best practices and standardizing infrastructure configurations.




Terraform Module Examples
Below are three examples demonstrating how to use Terraform modules.

Example 1: AWS VPC Module
Creating an AWS Virtual Private Cloud (VPC) is fundamental for many infrastructure deployments. Instead of defining the VPC configuration repeatedly, we can create a Terraform module for it.

Module Directory Structure:

modules/
  vpc/
	main.tf
	variables.tf
VPC Module Code (modules/vpc/main.tf):

resource "aws_vpc" "example" {
  cidr_block = var.cidr_block
  tags   	= { Name = var.name }
}
In this module, we define an AWS VPC resource and allow customization of the VPC and name using input variables.

Input Variables (modules/vpc/variables.tf):

variable "cidr_block" {
  description = "The CIDR block for the VPC."
}
 
variable "name" {
  description = "The name of the VPC."
}
The variables.tf file declares the input variables that can be set when the module is used.

Using the VPC Module (main.tf):

module "my_vpc" {
  source 	= "./modules/vpc"
  cidr_block = "10.0.0.0/16"
  name   	= "my-vpc"
}
In the main Terraform configuration, we use the module block to include the VPC module. We specify the module's source directory and provide values for the input variables.

Now, you can easily create multiple VPCs with different configurations by reusing this module.

Example 2: AWS EC2 Instance Module
Creating Amazon Elastic Compute Cloud (EC2) instances is another common task in AWS. Let's create a Terraform module for EC2 instances.

Module Directory Structure:

modules/
  ec2/
	main.tf
	variables.tf
EC2 Instance Module Code (modules/ec2/main.tf):

resource "aws_instance" "example" {
  ami       	= var.ami
  instance_type = var.instance_type
  subnet_id 	= var.subnet_id
  key_name  	= var.key_name
 
  tags = {
	Name = var.name
  }
}
In this module, we define an AWS EC2 instance resource and allow customization of the AMI, instance type, subnet, key name, and name using input variables.

Input Variables (modules/ec2/variables.tf):

variable "ami" {
  description = "The AMI ID for the EC2 instance."
}
 
variable "instance_type" {
  description = "The instance type for the EC2 instance."
}
 
variable "subnet_id" {
  description = "The subnet ID for the EC2 instance."
}
 
variable "key_name" {
  description = "Key pair to associate with the EC2 instance."
}
 
variable "name" {
  description = "The name of the EC2 instance."
}
The variables.tf file declares the input variables that can be set when using the module.

Using the EC2 Instance Module (main.tf):

module "my_ec2" {
  source    	= "./modules/ec2"
  ami       	= "ami-12345678"
  instance_type = "t2.micro"
  subnet_id 	= "subnet-01234567"
  key_name  	= "my-key-pair"
  name      	= "my-ec2-instance"
}
In the main Terraform configuration, we use the module block to include the EC2 instance module. We specify the module's source directory and provide values for the input variables.

With this module, you can easily create EC2 instances with different configurations across your infrastructure.

These examples demonstrate how Terraform modules promote code reuse, abstraction, and encapsulation. By following similar patterns, you can create modules for various infrastructure components, including databases, load balancers, and networking resources.


if module source is github 
github.com/CloudTechDevOps/Terraform/root_modules #for my github reference here root_module is source reference 


-------------------- # connection # ---------------------
Connection Block
You can create one or more connection blocks that describe how to access the remote resource. One use case for providing multiple connections is to have an initial provisioner connect as the root user to set up user accounts and then have subsequent provisioners connect as a user with more limited permissions.

Connection blocks don't take a block label and can be nested within either a resource or a provisioner.

A connection block nested directly within a resource affects all of that resource's provisioners.

Example:
connection {
    type        = "ssh"
    user        = "ubuntu"  # Replace with the appropriate username for your EC2 instance
    # private_key = file("C:/Users/veerababu/.ssh/id_rsa")
    private_key = file("~/.ssh/id_rsa")  #private key path
    host        = self.public_ip
  }


------------------------------## Output Values ## ---------------------------------------------------
Output values make information about your infrastructure available on the command line, and can expose information for other Terraform configurations to use.

Example:

output "instance_public_ip" {
    value = aws_instance.test.public_ip
    sensitive = true
}

output "instance_id"{
    value = aws_instance.test.id
}
output "instance_public_dns" {
    value = aws_instance.test.public_dns
  
}
output "instance_arn" {
    value = aws_instance.test.arn
  
}


----------------------------------------------------------------------------------------------
##conditions meta arguments :

variable "aws_region" {
  description = "The region in which to create the infrastructure"
  type        = string
  nullable    = false
  default     = "change me" #here we need to define either us-west-1 or eu-west-2 if i give other region will get error 
  validation {
    condition = var.aws_region == "us-west-2" || var.aws_region == "eu-west-1"
    error_message = "The variable 'aws_region' must be one of the following regions: us-west-2, eu-west-1"
  }
}

provider "aws" {
  region = var.aws_region
   
 }
--------------------------------------------------------------------------------------------------

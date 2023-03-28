variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}


variable "ec2_instance" {
  description = "AWS EC2 instance."
  type        = map
  default = {
    instance_type = "t2.micro"
    ami = "ami-005f9685cb30f234b"
    }
  
}

variable "public_subnets_count"{
    default = 2
}
variable "private_subnets_count"{
    default = 4
}
variable "availability_zones"{
    default =["us-east-1a","us-east-1b"]
}



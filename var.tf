variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "availability_zones"{
    default =["us-east-1a","us-east-1b"]
}

variable "public_subnets_count"{
    default = 2
}
variable "private_subnets_count"{
    default = 4
}

variable "ec2_instance" {
  description = "AWS EC2 instance."
  type        = map
  default = {
    instance_type = "t2.micro"
    ami = "ami-005f9685cb30f234b"
    }
  
}


variable "tags" {
  type = map
  
  default = {
    terraform = true
    project = "tfdeploy"
  }
}
variable"prefix"{
    type = string
    default = "quanna-"
}

variable "db_username" {
  type    = string

}
variable "db_password" {
  type    = string
  default = "mysecretpassword"
}

//讀取 terraform.tfvars 文件中定義的使用者名稱和密碼變數。這樣您就可以輕鬆地管理應用程式所需的機密資料，而不必在代碼中明文顯示它們。

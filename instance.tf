data "template_file" "config" {
  template = "${file("${path.module}/config.json")}"
}

//instance
resource "aws_instance" "bastion" {
    ami = var.ec2_instance["ami"] //console那邊會有固定且公開的AMI(Amazon linux)，一開始使用Console創立時，也都是使用那public的
    instance_type = var.ec2_instance["instance_type"]
    subnet_id = aws_subnet.public[0].id
    vpc_security_group_ids =[aws_security_group.sgbastion.id]
    key_name = "${var.prefix}ec2"
    tags = {
         Name = "quannabastion"
    }
}
resource "aws_instance" "web" {
    ami = var.ec2_instance["ami"] //console那邊會有固定且公開的AMI(Amazon linux)，一開始使用Console創立時，也都是使用那public的
    instance_type = var.ec2_instance["instance_type"]
    subnet_id = aws_subnet.private[0].id
    key_name = "${var.prefix}ec2"
    iam_instance_profile = "ec2-acces-s3"
    vpc_security_group_ids =[aws_security_group.sgweb.id]
    //每次創建EC2會執行
    user_data = <<-EOF
    #!/bin/bash
    #exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1 
    echo "Hello from user-data!"
    sudo yum update -y
    sudo yum install -y httpd.x86_64
    sudo yum install -y mysql
    sudo yum install -y php
    echo "Your IP address is: <?php echo \$_SERVER['REMOTE_ADDR']; ?>" > /var/www/html/index.php
    sudo systemctl start httpd.service
    sudo systemctl enable httpd.service
    #sudo yum install -y amazon-cloudwatch-agent
    wget  'https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm'
    sudo rpm -U ./amazon-cloudwatch-agent.rpm
    #sudo systemctl start amazon-cloudwatch-agent
    #sudo systemctl enable amazon-cloudwatch-agent
    echo '{
      "agent": {
        "metrics_collection_interval": 60,
      	"run_as_user": "root"
    	},
      "logs": {
      	"logs_collected": {
      	"files": {
          "collect_list": [
            {
              "file_path": "/var/log/httpd/access_log",
            	"log_group_name": "quanna_accesslog",
              "log_stream_name": "quanna_ec2log",
            	"retention_in_days": 14
        		}
          ]
        }
        }
      },
      "metrics": {
      	"aggregation_dimensions": [
        	["InstanceId"]
        ],
        "append_dimensions": {
          "AutoScalingGroupName": "$${aws:AutoScalingGroupName}",
        	"ImageId": "$${aws:ImageId}",
        	"InstanceId": "$${aws:InstanceId}",
          "InstanceType": "$${aws:InstanceType}"
        },
        "metrics_collected": {
          "disk": {
            "measurement": [
            "used_percent"
          	],
            "metrics_collection_interval": 60,
              "resources": [
                	"*"
              ]
          },
          "mem": {
            "measurement": [
              "mem_used_percent"
            ],
            "metrics_collection_interval": 60
          }
        }
        }
    }' > /opt/aws/amazon-cloudwatch-agent/bin/config.json
    sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json -s
    #sudo systemctl restart amazon-cloudwatch-agent
    sudo yum install -y amazon-efs-utils
    sudo /usr/local/bin/pip3 install botocore //使用 Amazon CloudWatch 監控檔案系統的掛載狀態
    sudo pip3 install botocore --upgrade
    sudo mkdir -p /mnt/efs
    sudo mount -t efs -o tls ${aws_efs_file_system.efs.id} :/ /mnt/efs //將資料掛載到/mnt/efs底下的根目錄
    touch /mnt/efs/test.txt
   # sudo mount -t efs -o tls ${aws_efs_file_system.efs.id} /mnt/efs //傳輸中資料的加密

    EOF
    
    tags = {
         Name = "${var.prefix}web"
    }
    
    depends_on = [aws_route_table.private_rt]


}
resource "aws_db_instance" "RDS" {
  allocated_storage    = 10
  db_name              = "quannards"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  vpc_security_group_ids =[aws_security_group.sgdb.id]
  db_subnet_group_name = aws_db_subnet_group.rds.name
  tags = merge(var.tags,{
       Name = "${var.prefix}rds"
  }  )
}

resource "aws_db_subnet_group" "rds" {
  name        = "quanna"
  description = "RDS subnet group"
  subnet_ids  = [
    aws_subnet.private[2].id,
    aws_subnet.private[3].id
  ]
  tags = {
       Name = "${var.prefix}subnetgroup"
  }  
}
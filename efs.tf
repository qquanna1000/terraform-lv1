resource "aws_efs_file_system" "efs" {
 # creation_token = "my-product"  //確認這個操作是針對哪個資源進行的
  encrypted = true
  
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
  tags = merge(var.tags,{
       Name = "${var.prefix}efs"
  }  )
}

resource "aws_efs_mount_target" "private1" {
  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = aws_subnet.private[0].id //1a地區
  security_groups =[aws_security_group.sgefs.id]
}
resource "aws_efs_mount_target" "private2" {
  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = aws_subnet.private[1].id //1b地區
  security_groups =[aws_security_group.sgefs.id] //要開2049
}
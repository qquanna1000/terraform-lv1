//alarm警告
resource "aws_cloudwatch_metric_alarm" "ec2_memory_used_alarm" {
  alarm_name          = "Quanna-alarm"
  comparison_operator = "GreaterThanThreshold" //大於
  evaluation_periods  = 1 //檢查幾次
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              =  60 //多久檢查一次
  statistic           = "Average"
  threshold           = 80 //超過多少會有警告
  alarm_description   = "This metric monitors EC2 instance cpu usage and triggers an alarm if it goes above 80%."
  alarm_actions = [aws_sns_topic.sns.arn] //list的意思=中括號
  dimensions = {
    InstanceId = aws_instance.web.id
  }
}

//sns設定
resource "aws_sns_topic" "sns" {
  name = "quanna-sns"
}
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.sns.arn
  protocol  = "email"
  endpoint  = "zoe900719@gmail.com"
}
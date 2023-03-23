//cloudwatch監控資源
resource "aws_cloudwatch_dashboard" "cloudwatch_mem_used" {
  dashboard_name = "quanna-ec2mem"
  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 9
        height = 6

        properties = {
          metrics = [
            [
              "CWAgent",
              "mem_used",
              "InstanceId",
              "${aws_instance.web.id}"
            ]
          ]
          period = 300 //週期
          stat   = "Average"
          region = "us-east-1"
          title  = "EC2 memory"
        }
      },
      {
        type   = "text"
        x      = 0
        y      = 7
        width  = 3
        height = 3
        
         properties = {
            markdown = "Hello world"
        }
      }
    ]
  })
}
/*
resource "aws_cloudwatch_log_group" "ec2_logs" {
  name = "/var/log/httpd/access.log"
}

resource "aws_cloudwatch_log_stream" "ec2_logs_stream" {
  name           = "ec2_logs_stream"
  log_group_name = aws_cloudwatch_log_group.ec2_logs.name
}
resource "aws_cloudwatch_log_metric_filter" "ec2_memory_used" {
  name           = "ec2_memory_used"
  pattern        = "Memory used:"
  log_group_name = aws_cloudwatch_log_group.ec2_logs.name

  metric_transformation {
    name      = "MemoryUsed"
    namespace = "CWAgent"
    value     = "$1"
    dimensions = {
      InstanceId = "aws_instance.web.id"
    }
  }
}
*/

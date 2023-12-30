resource "aws_cloudwatch_log_group" "web" {
  name              = "/ecs/project/dev/web"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "app" {
  name              = "/ecs/project/dev/app"
  retention_in_days = 30
}
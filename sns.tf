resource "aws_sns_topic" "pipeline_status" {
  count = var.github_notification_lambda_name == null ? 0 : 1
  name  = "${var.pipeline_name}-pipeline-status"
}

resource "aws_sns_topic_subscription" "pipeline_status" {
  count     = var.github_notification_lambda_name == null ? 0 : 1
  topic_arn = aws_sns_topic.pipeline_status[count.index].arn
  protocol  = "lambda"
  endpoint  = data.aws_lambda_function.github_function[count.index].arn
}
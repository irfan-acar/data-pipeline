resource "aws_codestarnotifications_notification_rule" "lambda_pipeline_status" {
  count       = var.github_notification_lambda_name == null ? 0 : 1
  detail_type = "FULL"
  event_type_ids = [
    "codepipeline-pipeline-pipeline-execution-failed",
    "codepipeline-pipeline-pipeline-execution-canceled",
  ]
  name     = "${var.pipeline_name}-status"
  resource = aws_codepipeline.codepipeline.arn

  target {
    address = aws_sns_topic.pipeline_status[count.index].arn
    type    = "SNS"
  }
}
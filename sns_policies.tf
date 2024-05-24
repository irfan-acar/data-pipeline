data "aws_iam_policy_document" "pipeline_status_policy" {
  count = var.github_notification_lambda_name == null ? 0 : 1
  statement {
    sid    = "codestar-notification"
    effect = "Allow"
    resources = [
      aws_sns_topic.pipeline_status[count.index].arn
    ]

    principals {
      identifiers = [
        "codestar-notifications.amazonaws.com"
      ]
      type = "Service"
    }
    actions = [
      "SNS:Publish"
    ]
  }
}

resource "aws_sns_topic_policy" "pipeline_status" {
  count  = var.github_notification_lambda_name == null ? 0 : 1
  arn    = aws_sns_topic.pipeline_status[count.index].arn
  policy = data.aws_iam_policy_document.pipeline_status_policy[count.index].json
}
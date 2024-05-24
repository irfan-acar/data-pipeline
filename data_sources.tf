data "aws_lambda_function" "github_function" {
  count         = var.github_notification_lambda_name == null ? 0 : 1
  function_name = var.github_notification_lambda_name
}

variable "account_id" {
  description = "Account ID to restrict SNS topic policies"
  type        = string
}

variable "artifact_bucket" {
  description = "Bucket to store the output artifacts from build stages"
  type        = string
}

variable "pipeline_name" {
  description = "Name to assign to the pipeline and resources"
  type        = string
}


variable "ecr_repo" {
  description = "ECR repository used when using ECR as a source pipeline stage"
  type        = string
  default     = null
}


variable "github_notification_lambda_name" {
  description = "Lambda function to associate with SNS for failed deployments"
  type        = string
  default     = null
}

variable "image_tag" {
  description = "Image tag used when using ECR as a source pipeline stage "
  type        = string
  default     = "latest"
}

variable "environment" {
  description = "Environment associated with all created resources"
  type        = string
  default     = "dev"
}
## Create this on the fly
variable "codedeploy_iam" {
  description = ""
  type        = string
  default     = "global-codedeploy-role"
}


variable "standard_sources" {
  description = "Predefined list of configured source groups must only be of type S3, GITHUB, or ECR. Multiples are allowed"
  type        = any
  default     = null
}

variable "build_stages" {
  description = "Predefined list of configured codebuild stages"
  type        = any
  default     = null
}

variable "lambda_stages" {
  description = "Predefined list of configured lambda stages"
  type        = any
  default     = null
}


variable "git_org" {
  description = "Github organization for checking source code out directly - used with standard_source type = GITHUB"
  type        = string
  default     = ""
}

variable "git_repo" {
  description = "Github repository for checking out source code directly - used with standard_source type = GITHUB"
  type        = string
  default     = ""
}

variable "branch" {
  description = "Github branch for checking out source code directly - used with standard_source type = GITHUB"
  type        = string
  default     = null
}

variable "build_on_source_change" {
  description = "Flag to set if you want to globally release a change on any source change"
  type        = bool
  default     = false
}

variable "codestar_connection" {
  description = "ARN of the codestar connection allowing the communication between AWS and Github - used with standard_source type = GITHUB"
  type        = string
  default     = null
}

variable "output_artifact_format" {
  description = "Artifact format for source code - either CODE_ZIP or CODEBUILD_CLONE_REF - the CODEBUILD_CLONE_REF option can only be used with a Codecommit upstream and CodeBuild downstream actions."
  type        = string
  default     = "CODE_ZIP"
}

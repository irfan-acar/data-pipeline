locals {
  source_map  = { for i, source in var.standard_sources : tostring(i) => source }
  git_keys    = compact([for i, source in local.source_map : source.type == "GITHUB" ? i : ""])
  git_sources = [for key in local.git_keys : lookup(local.source_map, key)]
}

resource "aws_codepipeline" "codepipeline" {
  name          = var.pipeline_name
  role_arn      = aws_iam_role.codepipeline_role.arn
  pipeline_type = "V2"


  artifact_store {
    location = var.artifact_bucket
    type     = "S3"
  }

  ## Default Prebuilt Source Stages for GITHUBv2
  dynamic "stage" {
    for_each = var.standard_sources
    content {
      name = "Source"
      dynamic "action" {
        for_each = stage.value.action
        content {
          name             = lookup(action.value, "name", "GithubV2Source")
          category         = "Source"
          owner            = "AWS"
          provider         = "CodeStarSourceConnection"
          version          = "1"
          run_order        = lookup(action.value, "run_order", "1")
          output_artifacts = [lookup(action.value, "artifact_name", "${title(action.value.type)}OutputArtifacts")]
          configuration = {
            ConnectionArn        = lookup(action.value, "codestar_connection", var.codestar_connection)
            FullRepositoryId     = lookup(action.value, "repo", "${var.git_org}/${var.git_repo}")
            BranchName           = lookup(action.value, "branch", var.branch)
            OutputArtifactFormat = lookup(action.value, "output_format", var.output_artifact_format)
            DetectChanges        = lookup(action.value, "poll", var.build_on_source_change)
          }
        }
      }
    }
  }

  ## Default Prebuilt Source Stages for GITHUBv2
  dynamic "trigger" {
    for_each = var.triggers

    content {
      provider_type = lookup(trigger.value, "provider_type", "CodeStarSourceConnection")
      git_configuration {
        source_action_name = lookup(trigger.value, "source_action_name", "GithubV2Source")
        pull_request {
          events = lookup(trigger.value, "events", [])
          branches {
            excludes = lookup(trigger.value, "excludes", [])
            includes = lookup(trigger.value, "includes", [])
          }

        }

      }
    }
  }



  ## Default Prebuilt CodebuildBuild Stage
  dynamic "stage" {
    for_each = var.build_stages
    content {
      name = stage.value.stage_name
      dynamic "action" {
        for_each = stage.value.action
        content {
          name             = lookup(action.value, "name", "default")
          category         = lookup(action.value, "category", "Build")
          owner            = lookup(action.value, "owner", "AWS")
          provider         = lookup(action.value, "provider", "CodeBuild")
          version          = lookup(action.value, "version", "1")
          run_order        = lookup(action.value, "run_order", "1")
          input_artifacts  = action.value.input_artifacts
          output_artifacts = [lookup(action.value, "artifact_name", "buildOutputArtifacts")]
          configuration = {
            ProjectName = action.value.project_name
          }
        }
      }
    }
  }
}
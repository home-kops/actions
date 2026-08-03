resource "github_actions_secret" "renovate_private_key" {
  count = length(var.repositories)

  repository  = var.repositories[count.index].name
  secret_name = "RENOVATE_PRIVATE_KEY"
  value       = var.renovate_private_key
}

resource "github_repository_ruleset" "main" {
  count = length(var.repositories)

  name        = "main"
  repository  = var.repositories[count.index].name
  target      = "branch"
  enforcement = "active"

  bypass_actors {
    actor_id    = 4307018
    actor_type  = "Integration"
    bypass_mode = "always"
  }

  bypass_actors {
    actor_id    = 21179154
    actor_type  = "User"
    bypass_mode = "always"
  }

  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
  }

  rules {
    deletion            = true
    required_signatures = true
    non_fast_forward    = true

    pull_request {
      allowed_merge_methods = ["squash"]
    }

    dynamic "required_status_checks" {
      for_each = length(var.repositories[count.index].required_checks) > 0 ? [1] : []

      content {
        dynamic "required_check" {
          for_each = var.repositories[count.index].required_checks

          content {
            context        = required_check.value["context"]
            integration_id = required_check.value["integration_id"]
          }
        }
      }
    }
  }
}

resource "github_repository_file" "renovate" {
  count = length(var.repositories)

  repository          = var.repositories[count.index].name
  file                = ".github/workflows/tf_renovate.yaml"
  content             = file("./templates/renovate.yaml")
  commit_message      = "create renovate workflow"
  overwrite_on_create = true
}

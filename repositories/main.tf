resource "github_actions_secret" "renovate_private_key" {
  count = length(var.repositories)

  repository  = var.repositories[count.index]
  secret_name = "RENOVATE_PRIVATE_KEY"
  value       = var.renovate_private_key
}

resource "github_repository_ruleset" "example" {
  count = length(var.repositories)

  name        = "main-test"
  repository  = var.repositories[count.index]
  target      = "branch"
  enforcement = "active"

  bypass_actors {
    actor_id    = 4307018
    actor_type  = "Integration"
    bypass_mode = "always"
  }

  bypass_actors {
    actor_type  = "OrganizationAdmin"
    bypass_mode = "always"
  }

  rules {
    deletion            = true
    required_signatures = true
    non_fast_forward    = true

    pull_request {
      allowed_merge_methods = ["squash"]
    }

    required_status_checks {
      required_check {
        context = "validate-k8s-manifests / validate-helm"
      }
      required_check {
        context = "validate-k8s-manifests / validate-kustomizations"
      }
    }
  }
}

resource "github_repository_file" "renovate" {
  count = length(var.repositories)

  repository          = var.repositories[count.index]
  file                = ".github/workflows/tf_renovate.yaml"
  content             = "./templates/renovate.yaml"
  commit_message      = "create renovate workflow"
  overwrite_on_create = true
}

resource "github_actions_secret" "renovate_private_key" {
  count = length(var.repositories)

  repository  = var.repositories[count.index]
  secret_name = "RENOVATE_PRIVATE_KEY"
  value       = var.renovate_private_key
}

resource "github_repository_file" "renovate" {
  count = length(var.repositories)

  repository          = var.repositories[count.index]
  file                = ".github/workflows/tf_renovate.yaml"
  content             = "./templates/renovate.yaml"
  commit_message      = "create renovate workflow"
  overwrite_on_create = true
}

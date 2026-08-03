variable "repositories" {
  type = list(object({
    name = string
    required_checks = list(object({
      context        = string
      integration_id = number
    }))
  }))
  default = [
    {
      name = "homelab-manifests"
      required_checks = [
        {
          context        = "validate-k8s-manifests / validate-helm"
          integration_id = 15368
        },
        {
          context        = "validate-k8s-manifests / validate-kustomizations"
          integration_id = 15368
        }
      ]
    },
    {
      name            = "gh-actions"
      required_checks = []
    }
  ]
}

variable "renovate_private_key" {
  type      = string
  sensitive = true
}

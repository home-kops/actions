variable "repositories" {
  type = list(string)
  default = [
    "homelab-manifests",
    "gh-actions"
  ]
}

variable "renovate_private_key" {
  type      = string
  sensitive = true
}

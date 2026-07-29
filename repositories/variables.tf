variable "repositories" {
  type = list(string)
  default = [
    "homelab-manifests",
  ]
}

variable "renovate_private_key" {
  type      = string
  sensitive = true
}

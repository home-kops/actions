variable "repositories" {
  type = list(string)
  default = [
    "msdeleyto/homelab-manifests",
  ]
}

variable "renovate_private_key" {
  type      = string
  sensitive = true
  default   = "secret"
}

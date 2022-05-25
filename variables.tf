variable "organization_identifier" {
  type    = string
  default = "default"
}

variable "project_identifier" {
  type    = string
}

variable "environment" {
  type = string
}

variable "pipeline_name" {
  type = string
}

variable "kubernetes_namespace" {
  type    = string
}

variable "connector_github_id" {
  type = string
}

variable "connector_kubernetes_id" {
  type = string
}

variable "branch" {
  type = string
  default = "main"
}

variable "server_manifest_path" {
  type = string
}

variable "server_manifest_values_path" {
  type = string
}

variable "client_manifest_path" {
  type = string
}

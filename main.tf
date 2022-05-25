data "harness_platform_organization" "this" {
  identifier = var.organization_identifier
}

data "harness_platform_project" "this" {
  org_id     = data.harness_platform_organization.this.id
  identifier = var.project_identifier
}

// This is a hack to get around the soft-delete problem with Harness.
resource "random_string" "this" {
  length  = 4
  special = false
  upper   = false
  number  = false
}

resource "harness_platform_environment" "this" {
  name       = var.environment
  identifier = "${replace(var.environment, " ", "_")}_${random_string.this.result}"
  org_id     = data.harness_platform_organization.this.id
  project_id = data.harness_platform_project.this.id
  type       = "PreProduction"
  color      = "#0063F7"
}

resource "harness_platform_service" "client" {
  identifier = "client_${random_string.this.result}"
  name       = "client"
  org_id     = data.harness_platform_organization.this.id
  project_id = data.harness_platform_project.this.id
}

resource "harness_platform_service" "server" {
  identifier = "server_${random_string.this.result}"
  name       = "server"
  org_id     = data.harness_platform_organization.this.id
  project_id = data.harness_platform_project.this.id
}

resource "harness_platform_pipeline" "this" {
  identifier = "${replace(var.pipeline_name, " ", "_")}_${random_string.this.result}"
  name       = var.pipeline_name
  org_id     = data.harness_platform_organization.this.id
  project_id = data.harness_platform_project.this.id

  yaml = templatefile("${path.module}/templates/pipeline.tpl", {
    unique_id               = random_string.this.result,
    identifier              = "${replace(var.pipeline_name, " ", "_")}_${random_string.this.result}",
    name                    = var.pipeline_name,
    org_identifier          = data.harness_platform_organization.this.id,
    project_identifier      = data.harness_platform_project.this.id,
    github_connector_id     = var.connector_github_id,
    environment_id          = harness_platform_environment.this.id,
    client_service_id       = harness_platform_service.client.id,
    server_service_id       = harness_platform_service.server.id,
    client_manifest_path    = var.client_manifest_path,
    server_manifest_path    = var.server_manifest_path,
    server_manifest_values_path = var.server_manifest_values_path,
    branch = var.branch,
    kubernetes_connector_id = var.connector_kubernetes_id,
    kubernetes_namespace    = var.kubernetes_namespace
  })
}


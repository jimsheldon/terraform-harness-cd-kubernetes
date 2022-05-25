# terraform-harness-cd-kubernetes

Terraform module which creates a Harness CD pipeline to deploy client and
server processes to a Kubernetes cluster.

## Usage

```hcl
data "harness_platform_organization" "example" {
  identifier = "default"
}

data "harness_platform_project" "example" {
  org_id     = data.harness_platform_organization.example.id
  identifier = "example"
}

// This is a hack to get around the soft-delete problem with Harness.
resource "random_string" "this" {
  length  = 4
  special = false
  upper   = false
  number  = false
}

resource "harness_platform_connector_github" "example" {
  connection_type = "Repo"
  credentials {
    http {
      token_ref = "github_token"
      username  = "octocat"
    }
  }
  identifier         = "example_${random_string.example.result}"
  name               = "example"
  url                = "https://github.com/octocat/example"
  org_id             = data.harness_platform_organization.example.id
  project_id         = data.harness_platform_project.example.id
  delegate_selectors = ["harnesscd"]
}

resource "harness_platform_connector_kubernetes" "example" {
  identifier = "example_${random_string.this.result}"
  name       = "my cluster"
  org_id     = data.harness_platform_organization.this.id
  project_id = data.harness_platform_project.this.id

  inherit_from_delegate {
    delegate_selectors = ["example"]
  }
}

module "pipeline" {
  source = "git::https://github.com/jimsheldon/terraform-harness-cd-kubernetes.git"

  environment                 = "example"
  pipeline_name               = "deploy_example"
  kubernetes_namespace        = "example"

  project_identifier          = data.harness_platform_project.example.id
  connector_github_id         = harness_platform_connector_github.example.id
  connector_kubernetes_id     = harness_platform_connector_kubernetes.example.id

  client_manifest_path        = "kubernetes/client-manifest.yaml"
  server_manifest_values_path = "kubernetes/server-manifest-values.yaml"
  server_manifest_path        = "kubernetes/server-manifest.yaml"
}
```

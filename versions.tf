terraform {
  required_version = ">= 0.13.1"

  required_providers {
    harness = {
      source  = "harness/harness"
      version = ">= 0.2.9"
    }

    random = {
      source  = "hashicorp/random"
      version = ">= 3.2.0"
    }
  }
}

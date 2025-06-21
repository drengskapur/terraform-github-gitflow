terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = ">= 5.0, < 7.0"
    }
  }
}

provider "github" {
  # Configure with GITHUB_TOKEN environment variable
}

module "branch_protection" {
  source = "../../"

  repository_full_name = "your-org/your-repo"
}

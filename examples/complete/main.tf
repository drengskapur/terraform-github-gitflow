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

  repository_full_name             = "your-org/your-repo"
  main_branch_required_reviews     = 2
  develop_branch_required_reviews  = 1
  require_code_owner_reviews       = true
  require_signed_commits           = true

  main_branch_status_checks = [
    "ci/build",
    "ci/test",
    "ci/security-scan",
    "ci/lint"
  ]

  develop_branch_status_checks = [
    "ci/build",
    "ci/test"
  ]
}

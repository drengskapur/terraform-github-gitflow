terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

# Configure the GitHub Provider
provider "github" {
  owner = var.github_owner
  # Token configuration will be taken from environment variables:
  # GITHUB_TOKEN or GITHUB_APP_*
}

variable "github_owner" {
  description = "GitHub organization or user name"
  type        = string
  default     = "your-github-org"
}

variable "repository_name" {
  description = "Name of the repository to create"
  type        = string
  default     = "your-repo-name"
}

module "gitflow" {
  source = "../.."

  # Repository Configuration
  github_owner          = var.github_owner
  repository_name       = var.repository_name
  repository_visibility = "private"

  # Basic GitFlow Configuration
  enable_gitflow = true

  # Branch Configuration - disable rulesets for GitHub Free plan
  enable_develop_branch   = true
  enable_feature_branches = false # Disable for fresh repos - no feature/* branches exist
  enable_release_branches = false # Disable for fresh repos - no release/* branches exist
  enable_hotfix_branches  = false # Disable for fresh repos - no hotfix/* branches exist

  # Disable features that require GitHub Pro
  enable_branch_protection_rulesets = false # Requires GitHub Pro for private repos
  enable_tag_protection              = false # Requires GitHub Pro
  enable_push_rules                  = false # Requires GitHub Pro

  # Environment Configuration - disable environments for GitHub Free plan
  enable_dev_environment   = false # Requires GitHub Pro or different token permissions
  enable_stage_environment = false # Requires GitHub Pro
  enable_prod_environment  = false # Requires GitHub Pro

  # Repository Settings
  repo_allow_merge_commit = true
  repo_allow_rebase_merge = true
  repo_allow_squash_merge = true
  repo_has_wiki           = true
  repo_has_projects       = false

  # Security Settings (disabled for personal accounts)
  enable_advanced_security               = false
  enable_secret_scanning                 = false
  enable_secret_scanning_push_protection = false
  enable_dependabot_security_updates     = true

  # Branch Protection
  main_branch_require_signed_commits    = true
  develop_branch_require_signed_commits = false
}

# Complete example demonstrating advanced GitFlow features
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
  # Configuration will be taken from environment variables:
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
  default     = "gitflow-repo"
}

module "gitflow_repository" {
  source = "../../"

  github_owner    = var.github_owner
  repository_name = var.repository_name

  # Full GitFlow Configuration
  enable_gitflow         = true
  enable_develop_branch  = true
  set_develop_as_default = false # Keep main as default for GitHub features

  # Repository settings
  repo_has_wiki     = true
  repo_has_projects = true

  # Enable all GitFlow branch types - disabled for integration testing with fresh repos
  enable_feature_branches = false # Disable for fresh repos - no feature/* branches exist
  enable_release_branches = false # Disable for fresh repos - no release/* branches exist
  enable_hotfix_branches  = false # Disable for fresh repos - no hotfix/* branches exist

  # Enhanced Protection Features
  enable_tag_protection  = true
  enable_push_rules      = true
  enable_codeowners_file = true

  # Corporate compliance
  commit_author_email_pattern = ""

  # File restrictions for security
  max_file_size_mb        = 10
  blocked_file_extensions = ["exe", "zip", "tar.gz", "dmg", "pkg", "msi"]

  # Comprehensive CODEOWNERS
  codeowners_content = <<-EOT
    # Global owners - require approval for all changes
    * @admins @security-team

    # Frontend applications
    /frontend/ @frontend-team
    /ui/ @frontend-team @ux-team

    # Backend services
    /backend/ @backend-team
    /api/ @backend-team @security-team

    # Infrastructure and deployment
    /terraform/ @devops-team @security-team
    /k8s/ @devops-team
    /.github/ @devops-team
    /Dockerfile* @devops-team

    # Security-sensitive files
    /secrets/ @security-team
    /.env* @security-team
    /security/ @security-team

    # Documentation
    /docs/ @tech-writers @product-team
    README.md @tech-writers
  EOT

  # Environment configuration
  enable_dev_environment   = true
  enable_stage_environment = false # Disabled for CI on free plans
  enable_prod_environment  = false # Disabled for CI on free plans

  dev_env_reviewers   = ["dev-leads"]
  stage_env_reviewers = ["qa-team", "dev-leads"]
  prod_env_reviewers  = ["ops-team", "security-team"]

  # CI compatibility: disable bypass actors (requires valid org IDs)
  bypass_actors = []

  # Security features - Enable these if you have GitHub Enterprise or Advanced Security
  # For production use with GitHub Enterprise, set these to true:
  enable_advanced_security               = false # Set to true with GitHub Enterprise
  enable_secret_scanning                 = false # Set to true with GitHub Enterprise
  enable_secret_scanning_push_protection = false # Set to true with GitHub Enterprise
  enable_dependabot_security_updates     = true  # Available on free accounts

  # Webhook for external integrations
  enable_webhook = true
  webhook_url    = "https://ci.acme-corp.com/github-webhook"
  webhook_events = ["push", "pull_request", "release"]

  # Topics management in Terraform
  manage_topics_in_terraform = true

  # Provider rate limiting for large organization
  github_write_delay_ms = 2000
  github_read_delay_ms  = 500
}

# Trunk-based repository module and outputs have been removed for CI testing
output "gitflow_repo_url" {
  value = module.gitflow_repository.repository_html_url
}

output "gitflow_configuration" {
  value = module.gitflow_repository.gitflow_configuration
}

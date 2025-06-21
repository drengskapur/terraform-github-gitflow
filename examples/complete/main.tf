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

variable "trunk_repository_name" {
  description = "Name of the trunk-based repository to create"
  type        = string
  default     = "trunk-based-repo"
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

  # All GitFlow branch types
  enable_feature_branches = true
  enable_release_branches = true
  enable_hotfix_branches  = true

  # Enhanced Protection Features
  enable_tag_protection  = true
  enable_push_rules      = true
  enable_codeowners_file = true

  # Corporate compliance
  commit_author_email_pattern = "@acme-corp\\.com$"

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
  enable_stage_environment = true
  enable_prod_environment  = true

  dev_env_reviewers   = ["dev-leads"]
  stage_env_reviewers = ["qa-team", "dev-leads"]
  prod_env_reviewers  = ["ops-team", "security-team"]

  # Emergency bypass for critical incidents
  # Note: actor_id must be the numeric team/user/app ID, not the name
  # To find team ID: gh api orgs/YOUR-ORG/teams/TEAM-NAME --jq '.id'
  # To find user ID: gh api users/USERNAME --jq '.id'
  bypass_actors = [
    {
      actor_id    = 12345678 # Replace with actual team ID
      actor_type  = "TEAM"
      bypass_mode = "pull_request"
    }
  ]

  # Security features - full suite
  enable_advanced_security               = true
  enable_secret_scanning                 = true
  enable_secret_scanning_push_protection = true
  enable_dependabot_security_updates     = true

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

# Example of trunk-based development configuration
module "trunk_based_repository" {
  source = "../../"

  github_owner    = var.github_owner
  repository_name = var.trunk_repository_name

  # Trunk-based development - disable GitFlow
  enable_gitflow        = false
  enable_develop_branch = false

  # Repository settings
  repo_has_wiki     = false
  repo_has_projects = true

  # Still want tag and push protection
  enable_tag_protection = true
  enable_push_rules     = true

  # Only production environment for deployments
  enable_prod_environment = true
  prod_env_reviewers      = ["ops-team"]

  # Security features
  enable_advanced_security               = true
  enable_secret_scanning                 = true
  enable_secret_scanning_push_protection = true
  enable_dependabot_security_updates     = true

  # Allow UI management of topics for flexibility
  manage_topics_in_terraform = false
}

# Outputs for both configurations
output "gitflow_repo_url" {
  value = module.gitflow_repository.repository_html_url
}

output "trunk_based_repo_url" {
  value = module.trunk_based_repository.repository_html_url
}

output "gitflow_configuration" {
  value = module.gitflow_repository.gitflow_configuration
}

output "trunk_based_configuration" {
  value = module.trunk_based_repository.gitflow_configuration
}

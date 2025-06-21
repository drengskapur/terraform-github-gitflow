# Example usage of the GitHub GitFlow module
# This demonstrates how to use the module in your own Terraform configuration

module "github_gitflow" {
  source = "./modules/github-gitflow"

  # Required variables
  github_owner    = "drengskapur"
  repository_name = "terraform-github-gitflow"

  # Optional: Configure GitFlow workflow
  enable_gitflow = true

  # Optional: Customize branch names
  main_branch_name    = "main"
  develop_branch_name = "develop"

  # Optional: Repository settings
  repository_visibility = "private"

  # Optional: Security features
  enable_advanced_security               = true
  enable_secret_scanning                 = true
  enable_secret_scanning_push_protection = true
  enable_dependabot_security_updates     = true

  # Optional: Branch protection settings
  main_branch_require_signed_commits = true

  # Optional: Bypass actors for emergency access
  bypass_actors = [
    {
      actor_id    = "1" # OrganizationAdmin
      actor_type  = "OrganizationAdmin"
      bypass_mode = "always"
    }
  ]

  # Optional: Environment protection
  enable_dev_environment   = true
  enable_stage_environment = true
  enable_prod_environment  = true

  prod_env_reviewers = ["admin-team"]
}

# Outputs from the module
output "repository_url" {
  description = "The URL of the created repository"
  value       = module.github_gitflow.repository_html_url
}

output "repository_ssh_clone_url" {
  description = "The SSH clone URL of the repository"
  value       = module.github_gitflow.repository_ssh_clone_url
}

output "default_branch" {
  description = "The main branch name of the repository"
  value       = module.github_gitflow.main_branch_name
}

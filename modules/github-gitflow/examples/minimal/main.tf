module "gitflow" {
  source = "../../"

  github_owner    = "your-github-org"
  repository_name = "your-repo-name"

  # GitFlow Configuration
  enable_gitflow         = true # Set to false for trunk-based development
  enable_develop_branch  = true
  set_develop_as_default = false # Keep main as default branch

  # Repository settings
  repo_has_wiki      = true
  prod_env_reviewers = ["ops-team"]

  # Enable all GitFlow branch types
  enable_feature_branches = true
  enable_release_branches = true
  enable_hotfix_branches  = true

  # Enhanced Protection Features
  enable_tag_protection  = true
  enable_push_rules      = true
  enable_codeowners_file = true

  # Corporate email enforcement (optional)
  commit_author_email_pattern = "@your-company\\.com$"

  # File restrictions
  max_file_size_mb        = 5
  blocked_file_extensions = ["exe", "zip", "tar.gz", "dmg"]

  # CODEOWNERS configuration
  codeowners_content = <<-EOT
    # Global owners
    * @admins @security-team

    # Frontend code
    /frontend/ @frontend-team

    # Backend code
    /backend/ @backend-team

    # Infrastructure
    /terraform/ @devops-team
    /.github/ @devops-team
  EOT

  # Security features
  enable_advanced_security               = true
  enable_secret_scanning                 = true
  enable_secret_scanning_push_protection = true
  enable_dependabot_security_updates     = true

  # Topics management
  manage_topics_in_terraform = true
}

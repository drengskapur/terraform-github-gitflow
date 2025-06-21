module "gitflow" {
  source = "../../"

  github_owner    = "your-github-org"
  repository_name = "your-repo-name"

  # PAT picked from env var GITHUB_TOKEN
  enable_develop_branch    = true
  set_develop_as_default   = false

  repo_has_wiki       = true
  prod_env_reviewers  = ["ops-team"]
  
  # Enable all GitFlow branch types
  enable_feature_branches = true
  enable_release_branches = true
  enable_hotfix_branches  = true
  
  # Security features
  enable_advanced_security                = true
  enable_secret_scanning                  = true
  enable_secret_scanning_push_protection  = true
  enable_dependabot_security_updates      = true
}

# Data source to get repository information
data "github_repository" "repo" {
  full_name = var.repository_full_name
}

# Create develop branch if it doesn't exist
resource "github_branch" "develop" {
  repository = data.github_repository.repo.name
  branch     = "develop"
}

# Main branch protection rules
resource "github_branch_protection" "main" {
  repository_id = data.github_repository.repo.node_id
  pattern       = "main"

  # Require status checks to pass before merging
  required_status_checks {
    strict = true
    # Add contexts as needed, e.g., ["ci/build", "ci/test"]
    contexts = var.main_branch_status_checks
  }

  # Require pull request reviews before merging
  required_pull_request_reviews {
    required_approving_review_count = var.main_branch_required_reviews
    dismiss_stale_reviews          = true
    require_code_owner_reviews     = var.require_code_owner_reviews
    require_last_push_approval     = true
    restrict_dismissals            = false
  }

  # Additional protection settings
  enforce_admins         = false
  require_signed_commits = var.require_signed_commits
  allows_deletions       = false
  allows_force_pushes    = false
  lock_branch           = false
}

# Develop branch protection rules (less strict)
resource "github_branch_protection" "develop" {
  repository_id = data.github_repository.repo.node_id
  pattern       = "develop"

  # Require status checks to pass before merging
  required_status_checks {
    strict = true
    contexts = var.develop_branch_status_checks
  }

  # Require pull request reviews before merging
  required_pull_request_reviews {
    required_approving_review_count = var.develop_branch_required_reviews
    dismiss_stale_reviews          = true
    require_code_owner_reviews     = false
    require_last_push_approval     = false
    restrict_dismissals            = false
  }

  # Additional protection settings (more permissive than main)
  enforce_admins      = false
  allows_deletions    = false
  allows_force_pushes = false
  lock_branch        = false

  depends_on = [github_branch.develop]
}

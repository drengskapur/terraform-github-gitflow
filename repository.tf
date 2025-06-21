###############################################################################
# CORE GITHUB REPOSITORY
###############################################################################

resource "github_repository" "this" {
  name        = var.repository_name
  description = "Managed via Terraform GitFlow module"
  visibility  = var.repository_visibility

  allow_merge_commit = var.repo_allow_merge_commit
  allow_rebase_merge = var.repo_allow_rebase_merge
  allow_squash_merge = var.repo_allow_squash_merge

  has_wiki     = var.repo_has_wiki
  has_projects = var.repo_has_projects

  auto_init = true

  # Repository topics (managed only when enabled)
  topics = var.manage_topics_in_terraform ? var.repository_topics : []

  security_and_analysis {
    advanced_security {
      status = var.enable_advanced_security ? "enabled" : "disabled"
    }
    secret_scanning {
      status = var.enable_secret_scanning ? "enabled" : "disabled"
    }
    secret_scanning_push_protection {
      status = var.enable_secret_scanning_push_protection ? "enabled" : "disabled"
    }
  }

  vulnerability_alerts = var.enable_dependabot_security_updates

  lifecycle {
    ignore_changes = [
      # allow manual changes to topics when not managed via Terraform
      topics,
    ]
  }
}

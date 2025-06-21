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

  # Only include security_and_analysis block if any security features are enabled
  # Setting these to "disabled" requires GitHub Enterprise on personal accounts
  dynamic "security_and_analysis" {
    for_each = var.enable_advanced_security || var.enable_secret_scanning || var.enable_secret_scanning_push_protection ? [1] : []
    content {
      dynamic "advanced_security" {
        for_each = var.enable_advanced_security ? [1] : []
        content {
          status = "enabled"
        }
      }
      dynamic "secret_scanning" {
        for_each = var.enable_secret_scanning ? [1] : []
        content {
          status = "enabled"
        }
      }
      dynamic "secret_scanning_push_protection" {
        for_each = var.enable_secret_scanning_push_protection ? [1] : []
        content {
          status = "enabled"
        }
      }
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

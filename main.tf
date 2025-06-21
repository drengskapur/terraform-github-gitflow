# Terraform configuration for comprehensive GitFlow implementation on GitHub
# This module implements the most idiomatic GitFlow setup for GitHub repositories
# following modern best practices and GitHub's latest features

# Configure the GitHub Provider with flexible authentication options
provider "github" {
  # Authentication - supports multiple methods:
  # 1. Personal Access Token (recommended for most use cases)
  # 2. GitHub CLI authentication (gh auth login)
  # 3. GitHub App authentication (for organizations)
  # 4. Environment variables (GITHUB_TOKEN, GITHUB_OWNER, etc.)
  
  token    = var.github_token    # Can be null to use GITHUB_TOKEN env var or GitHub CLI
  owner    = var.github_owner    # Can be null to use GITHUB_OWNER env var
  base_url = var.github_base_url # Required for GitHub Enterprise Server
  
  # GitHub App authentication (alternative to token)
  dynamic "app_auth" {
    for_each = var.github_app_auth != null ? [var.github_app_auth] : []
    content {
      id              = app_auth.value.id
      installation_id = app_auth.value.installation_id
      pem_file        = app_auth.value.pem_file
    }
  }
  
  # Rate limiting and retry configuration
  write_delay_ms    = var.github_write_delay_ms
  read_delay_ms     = var.github_read_delay_ms
  retry_delay_ms    = var.github_retry_delay_ms
  max_retries       = var.github_max_retries
  retryable_errors  = var.github_retryable_errors
}

# Data source to get repository information
data "github_repository" "repo" {
  full_name = var.repository_full_name
}

# Get organization information for team and app configurations
data "github_organization" "org" {
  count = var.organization_name != null ? 1 : 0
  name  = var.organization_name
}

# Create develop branch if it doesn't exist
resource "github_branch" "develop" {
  count      = var.create_develop_branch ? 1 : 0
  repository = data.github_repository.repo.name
  branch     = var.develop_branch_name

  # Create from main branch by default
  source_branch = var.main_branch_name
}

# Set develop as default branch if specified
resource "github_branch_default" "develop_default" {
  count      = var.set_develop_as_default ? 1 : 0
  repository = data.github_repository.repo.name
  branch     = var.develop_branch_name

  depends_on = [github_branch.develop]
}

# Configure repository settings for GitFlow
resource "github_repository" "gitflow_settings" {
  count = var.configure_repository_settings ? 1 : 0
  name  = data.github_repository.repo.name

  # GitFlow-specific settings
  allow_merge_commit     = var.allow_merge_commit
  allow_squash_merge     = var.allow_squash_merge
  allow_rebase_merge     = var.allow_rebase_merge
  delete_branch_on_merge = var.delete_branch_on_merge

  # Security and quality settings
  vulnerability_alerts                    = var.enable_vulnerability_alerts
  has_issues                             = var.enable_issues
  has_projects                           = var.enable_projects
  has_wiki                               = var.enable_wiki
  has_discussions                        = var.enable_discussions
  allow_auto_merge                       = var.allow_auto_merge
  allow_update_branch                    = var.allow_update_branch

  # Advanced security features
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

  lifecycle {
    ignore_changes = [
      # Ignore changes to these attributes to avoid conflicts
      description,
      homepage_url,
      topics,
      visibility,
    ]
  }
}

# Enable Dependabot security updates for automated dependency management
resource "github_repository_dependabot_security_updates" "main" {
  count      = var.enable_dependabot_security_updates ? 1 : 0
  repository = data.github_repository.repo.name
  enabled    = true

  depends_on = [github_repository.gitflow_settings]
}

# Main branch ruleset - Production branch protection
resource "github_repository_ruleset" "main_branch" {
  name        = var.main_branch_ruleset_name
  repository  = data.github_repository.repo.name
  target      = "branch"
  enforcement = var.main_branch_enforcement

  conditions {
    ref_name {
      include = [var.main_branch_name]
      exclude = []
    }
  }

  rules {
    # Prevent direct pushes and force pushes
    creation                      = false
    deletion                      = true
    non_fast_forward              = true
    update                        = var.main_branch_allow_updates
    update_allows_fetch_and_merge = var.main_branch_update_allows_fetch_and_merge

    # Require linear history for clean GitFlow
    required_linear_history = var.main_branch_require_linear_history

    # Pull request requirements
    pull_request {
      required_approving_review_count   = var.main_branch_required_reviews
      dismiss_stale_reviews_on_push     = var.main_branch_dismiss_stale_reviews
      require_code_owner_review         = var.main_branch_require_code_owner_reviews
      require_last_push_approval        = var.main_branch_require_last_push_approval
      required_review_thread_resolution = var.main_branch_require_conversation_resolution
    }

    # Status check requirements
    dynamic "required_status_checks" {
      for_each = length(var.main_branch_status_checks) > 0 ? [1] : []
      content {
        strict_required_status_checks_policy = var.main_branch_strict_status_checks
        do_not_enforce_on_create            = var.main_branch_status_checks_do_not_enforce_on_create

        dynamic "required_check" {
          for_each = var.main_branch_status_checks
          content {
            context        = required_check.value.context
            integration_id = lookup(required_check.value, "integration_id", null)
          }
        }
      }
    }

    # Commit requirements
    required_signatures = var.main_branch_require_signed_commits

    # Commit message pattern enforcement
    dynamic "commit_message_pattern" {
      for_each = var.main_branch_commit_message_pattern != null ? [1] : []
      content {
        name     = "Conventional Commits"
        negate   = false
        operator = "regex"
        pattern  = var.main_branch_commit_message_pattern
      }
    }

    # Commit author email pattern
    dynamic "commit_author_email_pattern" {
      for_each = var.main_branch_commit_author_email_pattern != null ? [1] : []
      content {
        name     = "Authorized Committers"
        negate   = false
        operator = "regex"
        pattern  = var.main_branch_commit_author_email_pattern
      }
    }

    # Committer email pattern
    dynamic "committer_email_pattern" {
      for_each = var.main_branch_committer_email_pattern != null ? [1] : []
      content {
        name     = "Authorized Committers"
        negate   = false
        operator = "regex"
        pattern  = var.main_branch_committer_email_pattern
      }
    }

    # Branch name pattern for feature branches
    dynamic "branch_name_pattern" {
      for_each = var.main_branch_name_pattern != null ? [1] : []
      content {
        name     = "Branch Naming"
        negate   = false
        operator = "regex"
        pattern  = var.main_branch_name_pattern
      }
    }

    # Tag name pattern
    dynamic "tag_name_pattern" {
      for_each = var.main_branch_tag_name_pattern != null ? [1] : []
      content {
        name     = "Tag Naming"
        negate   = false
        operator = "regex"
        pattern  = var.main_branch_tag_name_pattern
      }
    }



    # Required deployments
    dynamic "required_deployments" {
      for_each = length(var.main_branch_required_deployments) > 0 ? [1] : []
      content {
        required_deployment_environments = var.main_branch_required_deployments
      }
    }

    # Merge queue
    dynamic "merge_queue" {
      for_each = var.main_branch_enable_merge_queue ? [1] : []
      content {
        check_response_timeout_minutes       = var.main_branch_merge_queue_check_timeout
        grouping_strategy                    = var.main_branch_merge_queue_grouping_strategy
        max_entries_to_build                 = var.main_branch_merge_queue_max_entries_to_build
        max_entries_to_merge                 = var.main_branch_merge_queue_max_entries_to_merge
        merge_method                         = var.main_branch_merge_queue_merge_method
        min_entries_to_merge                 = var.main_branch_merge_queue_min_entries_to_merge
        min_entries_to_merge_wait_minutes    = var.main_branch_merge_queue_min_entries_to_merge_wait_minutes
      }
    }

    # Required code scanning
    dynamic "required_code_scanning" {
      for_each = length(var.main_branch_required_code_scanning) > 0 ? [1] : []
      content {
        dynamic "required_code_scanning_tool" {
          for_each = var.main_branch_required_code_scanning
          content {
            tool                      = required_code_scanning_tool.value.tool
            alerts_threshold          = required_code_scanning_tool.value.alerts_threshold
            security_alerts_threshold = required_code_scanning_tool.value.security_alerts_threshold
          }
        }
      }
    }
  }

  # Bypass actors for emergency situations
  dynamic "bypass_actors" {
    for_each = var.main_branch_bypass_actors
    content {
      actor_id    = bypass_actors.value.actor_id
      actor_type  = bypass_actors.value.actor_type
      bypass_mode = bypass_actors.value.bypass_mode
    }
  }
}

# Develop branch ruleset - Integration branch protection
resource "github_repository_ruleset" "develop_branch" {
  count       = var.create_develop_branch ? 1 : 0
  name        = var.develop_branch_ruleset_name
  repository  = data.github_repository.repo.name
  target      = "branch"
  enforcement = var.develop_branch_enforcement

  conditions {
    ref_name {
      include = [var.develop_branch_name]
      exclude = []
    }
  }

  rules {
    # Less restrictive than main branch
    creation                      = false
    deletion                      = true
    non_fast_forward              = var.develop_branch_prevent_force_push
    update                        = var.develop_branch_allow_updates
    update_allows_fetch_and_merge = var.develop_branch_update_allows_fetch_and_merge

    # Allow merge commits for GitFlow
    required_linear_history = var.develop_branch_require_linear_history

    # Pull request requirements (less strict than main)
    pull_request {
      required_approving_review_count   = var.develop_branch_required_reviews
      dismiss_stale_reviews_on_push     = var.develop_branch_dismiss_stale_reviews
      require_code_owner_review         = var.develop_branch_require_code_owner_reviews
      require_last_push_approval        = var.develop_branch_require_last_push_approval
      required_review_thread_resolution = var.develop_branch_require_conversation_resolution
    }

    # Status check requirements
    dynamic "required_status_checks" {
      for_each = length(var.develop_branch_status_checks) > 0 ? [1] : []
      content {
        strict_required_status_checks_policy = var.develop_branch_strict_status_checks
        do_not_enforce_on_create            = var.develop_branch_status_checks_do_not_enforce_on_create

        dynamic "required_check" {
          for_each = var.develop_branch_status_checks
          content {
            context        = required_check.value.context
            integration_id = lookup(required_check.value, "integration_id", null)
          }
        }
      }
    }

    # Commit message pattern enforcement
    dynamic "commit_message_pattern" {
      for_each = var.develop_branch_commit_message_pattern != null ? [1] : []
      content {
        name     = "Conventional Commits"
        negate   = false
        operator = "regex"
        pattern  = var.develop_branch_commit_message_pattern
      }
    }

    # Required deployments
    dynamic "required_deployments" {
      for_each = length(var.develop_branch_required_deployments) > 0 ? [1] : []
      content {
        required_deployment_environments = var.develop_branch_required_deployments
      }
    }

    # Merge queue
    dynamic "merge_queue" {
      for_each = var.develop_branch_enable_merge_queue ? [1] : []
      content {
        check_response_timeout_minutes       = var.develop_branch_merge_queue_check_timeout
        grouping_strategy                    = var.develop_branch_merge_queue_grouping_strategy
        max_entries_to_build                 = var.develop_branch_merge_queue_max_entries_to_build
        max_entries_to_merge                 = var.develop_branch_merge_queue_max_entries_to_merge
        merge_method                         = var.develop_branch_merge_queue_merge_method
        min_entries_to_merge                 = var.develop_branch_merge_queue_min_entries_to_merge
        min_entries_to_merge_wait_minutes    = var.develop_branch_merge_queue_min_entries_to_merge_wait_minutes
      }
    }

    # Required code scanning
    dynamic "required_code_scanning" {
      for_each = length(var.develop_branch_required_code_scanning) > 0 ? [1] : []
      content {
        dynamic "required_code_scanning_tool" {
          for_each = var.develop_branch_required_code_scanning
          content {
            tool                      = required_code_scanning_tool.value.tool
            alerts_threshold          = required_code_scanning_tool.value.alerts_threshold
            security_alerts_threshold = required_code_scanning_tool.value.security_alerts_threshold
          }
        }
      }
    }
  }

  # Bypass actors with more permissive access
  dynamic "bypass_actors" {
    for_each = var.develop_branch_bypass_actors
    content {
      actor_id    = bypass_actors.value.actor_id
      actor_type  = bypass_actors.value.actor_type
      bypass_mode = bypass_actors.value.bypass_mode
    }
  }

  depends_on = [github_branch.develop]
}

# Feature branch ruleset - Development branch protection
resource "github_repository_ruleset" "feature_branches" {
  count       = var.enable_feature_branch_protection ? 1 : 0
  name        = var.feature_branch_ruleset_name
  repository  = data.github_repository.repo.name
  target      = "branch"
  enforcement = var.feature_branch_enforcement

  conditions {
    ref_name {
      include = var.feature_branch_patterns
      exclude = [var.main_branch_name, var.develop_branch_name]
    }
  }

  rules {
    # Basic protections for feature branches
    creation         = true
    deletion         = var.feature_branch_allow_deletion
    non_fast_forward = false
    update           = true

    # Minimal pull request requirements
    dynamic "pull_request" {
      for_each = var.feature_branch_require_pr ? [1] : []
      content {
        required_approving_review_count   = var.feature_branch_required_reviews
        dismiss_stale_reviews_on_push     = var.feature_branch_dismiss_stale_reviews
        require_code_owner_review         = false
        require_last_push_approval        = false
        required_review_thread_resolution = var.feature_branch_require_conversation_resolution
      }
    }

    # Status checks for feature branches
    dynamic "required_status_checks" {
      for_each = length(var.feature_branch_status_checks) > 0 ? [1] : []
      content {
        strict_required_status_checks_policy = var.feature_branch_strict_status_checks

        dynamic "required_check" {
          for_each = var.feature_branch_status_checks
          content {
            context        = required_check.value.context
            integration_id = lookup(required_check.value, "integration_id", null)
          }
        }
      }
    }

    # Branch naming enforcement
    dynamic "branch_name_pattern" {
      for_each = var.feature_branch_name_pattern != null ? [1] : []
      content {
        name     = "Feature Branch Naming"
        negate   = false
        operator = "regex"
        pattern  = var.feature_branch_name_pattern
      }
    }

    # Commit message pattern
    dynamic "commit_message_pattern" {
      for_each = var.feature_branch_commit_message_pattern != null ? [1] : []
      content {
        name     = "Conventional Commits"
        negate   = false
        operator = "regex"
        pattern  = var.feature_branch_commit_message_pattern
      }
    }
  }

  # Bypass actors for feature branches
  dynamic "bypass_actors" {
    for_each = var.feature_branch_bypass_actors
    content {
      actor_id    = bypass_actors.value.actor_id
      actor_type  = bypass_actors.value.actor_type
      bypass_mode = bypass_actors.value.bypass_mode
    }
  }
}

# Release branch ruleset - Release preparation protection
resource "github_repository_ruleset" "release_branches" {
  count       = var.enable_release_branch_protection ? 1 : 0
  name        = var.release_branch_ruleset_name
  repository  = data.github_repository.repo.name
  target      = "branch"
  enforcement = var.release_branch_enforcement

  conditions {
    ref_name {
      include = var.release_branch_patterns
      exclude = [var.main_branch_name, var.develop_branch_name]
    }
  }

  rules {
    # Strict protections for release branches
    creation         = true
    deletion         = var.release_branch_allow_deletion
    non_fast_forward = var.release_branch_prevent_force_push
    update           = var.release_branch_allow_updates

    # Require linear history for clean releases
    required_linear_history = var.release_branch_require_linear_history

    # Strict pull request requirements
    pull_request {
      required_approving_review_count   = var.release_branch_required_reviews
      dismiss_stale_reviews_on_push     = var.release_branch_dismiss_stale_reviews
      require_code_owner_review         = var.release_branch_require_code_owner_reviews
      require_last_push_approval        = var.release_branch_require_last_push_approval
      required_review_thread_resolution = var.release_branch_require_conversation_resolution
    }

    # Comprehensive status checks for releases
    dynamic "required_status_checks" {
      for_each = length(var.release_branch_status_checks) > 0 ? [1] : []
      content {
        strict_required_status_checks_policy = var.release_branch_strict_status_checks

        dynamic "required_check" {
          for_each = var.release_branch_status_checks
          content {
            context        = required_check.value.context
            integration_id = lookup(required_check.value, "integration_id", null)
          }
        }
      }
    }

    # Branch naming enforcement
    dynamic "branch_name_pattern" {
      for_each = var.release_branch_name_pattern != null ? [1] : []
      content {
        name     = "Release Branch Naming"
        negate   = false
        operator = "regex"
        pattern  = var.release_branch_name_pattern
      }
    }

    # Commit message pattern
    dynamic "commit_message_pattern" {
      for_each = var.release_branch_commit_message_pattern != null ? [1] : []
      content {
        name     = "Conventional Commits"
        negate   = false
        operator = "regex"
        pattern  = var.release_branch_commit_message_pattern
      }
    }

    # Signed commits for releases
    required_signatures = var.release_branch_require_signed_commits
  }

  # Limited bypass actors for releases
  dynamic "bypass_actors" {
    for_each = var.release_branch_bypass_actors
    content {
      actor_id    = bypass_actors.value.actor_id
      actor_type  = bypass_actors.value.actor_type
      bypass_mode = bypass_actors.value.bypass_mode
    }
  }
}

# Hotfix branch ruleset - Emergency fix protection
resource "github_repository_ruleset" "hotfix_branches" {
  count       = var.enable_hotfix_branch_protection ? 1 : 0
  name        = var.hotfix_branch_ruleset_name
  repository  = data.github_repository.repo.name
  target      = "branch"
  enforcement = var.hotfix_branch_enforcement

  conditions {
    ref_name {
      include = var.hotfix_branch_patterns
      exclude = [var.main_branch_name, var.develop_branch_name]
    }
  }

  rules {
    # Balanced protections for hotfixes
    creation         = true
    deletion         = var.hotfix_branch_allow_deletion
    non_fast_forward = var.hotfix_branch_prevent_force_push
    update           = var.hotfix_branch_allow_updates

    # Require linear history
    required_linear_history = var.hotfix_branch_require_linear_history

    # Streamlined but quality-focused reviews
    pull_request {
      required_approving_review_count   = var.hotfix_branch_required_reviews
      dismiss_stale_reviews_on_push     = var.hotfix_branch_dismiss_stale_reviews
      require_code_owner_review         = var.hotfix_branch_require_code_owner_reviews
      require_last_push_approval        = var.hotfix_branch_require_last_push_approval
      required_review_thread_resolution = var.hotfix_branch_require_conversation_resolution
    }

    # Essential status checks only
    dynamic "required_status_checks" {
      for_each = length(var.hotfix_branch_status_checks) > 0 ? [1] : []
      content {
        strict_required_status_checks_policy = var.hotfix_branch_strict_status_checks

        dynamic "required_check" {
          for_each = var.hotfix_branch_status_checks
          content {
            context        = required_check.value.context
            integration_id = lookup(required_check.value, "integration_id", null)
          }
        }
      }
    }

    # Branch naming enforcement
    dynamic "branch_name_pattern" {
      for_each = var.hotfix_branch_name_pattern != null ? [1] : []
      content {
        name     = "Hotfix Branch Naming"
        negate   = false
        operator = "regex"
        pattern  = var.hotfix_branch_name_pattern
      }
    }

    # Commit message pattern
    dynamic "commit_message_pattern" {
      for_each = var.hotfix_branch_commit_message_pattern != null ? [1] : []
      content {
        name     = "Conventional Commits"
        negate   = false
        operator = "regex"
        pattern  = var.hotfix_branch_commit_message_pattern
      }
    }

    # Signed commits for hotfixes
    required_signatures = var.hotfix_branch_require_signed_commits
  }

  # More permissive bypass for emergency situations
  dynamic "bypass_actors" {
    for_each = var.hotfix_branch_bypass_actors
    content {
      actor_id    = bypass_actors.value.actor_id
      actor_type  = bypass_actors.value.actor_type
      bypass_mode = bypass_actors.value.bypass_mode
    }
  }
}

# Push ruleset for repository-wide push restrictions
resource "github_repository_ruleset" "push_restrictions" {
  count       = var.enable_push_restrictions ? 1 : 0
  name        = var.push_restrictions_ruleset_name
  repository  = data.github_repository.repo.name
  target      = "branch"
  enforcement = var.push_restrictions_enforcement

  conditions {
    ref_name {
      include = ["~ALL"]
      exclude = []
    }
  }

  rules {
    # Basic push restrictions
    creation         = false
    deletion         = true
    non_fast_forward = true
    update           = true
  }

  # Bypass actors for push restrictions
  dynamic "bypass_actors" {
    for_each = var.push_restrictions_bypass_actors
    content {
      actor_id    = bypass_actors.value.actor_id
      actor_type  = bypass_actors.value.actor_type
      bypass_mode = bypass_actors.value.bypass_mode
    }
  }
}

# Tag protection ruleset
resource "github_repository_ruleset" "tag_protection" {
  count       = var.enable_tag_protection ? 1 : 0
  name        = var.tag_protection_ruleset_name
  repository  = data.github_repository.repo.name
  target      = "tag"
  enforcement = var.tag_protection_enforcement

  conditions {
    ref_name {
      include = var.tag_protection_patterns
      exclude = []
    }
  }

  rules {
    # Protect tags from deletion and modification
    creation = var.tag_allow_creation
    deletion = var.tag_allow_deletion
    update   = var.tag_allow_updates

    # Tag naming pattern
    dynamic "tag_name_pattern" {
      for_each = var.tag_name_pattern != null ? [1] : []
      content {
        name     = "Tag Naming Convention"
        negate   = false
        operator = "regex"
        pattern  = var.tag_name_pattern
      }
    }

    # Require signed commits for tags
    required_signatures = var.tag_require_signed_commits
  }

  # Bypass actors for tag operations
  dynamic "bypass_actors" {
    for_each = var.tag_protection_bypass_actors
    content {
      actor_id    = bypass_actors.value.actor_id
      actor_type  = bypass_actors.value.actor_type
      bypass_mode = bypass_actors.value.bypass_mode
    }
  }
}

# Repository environments for GitFlow deployment stages
resource "github_repository_environment" "development" {
  count       = var.create_development_environment ? 1 : 0
  repository  = data.github_repository.repo.name
  environment = var.development_environment_name

  # Development environment can be deployed from develop branch
  deployment_branch_policy {
    protected_branches     = false
    custom_branch_policies = true
  }

  # Reviewers for development deployments
  dynamic "reviewers" {
    for_each = var.development_environment_reviewers
    content {
      teams = lookup(reviewers.value, "teams", [])
      users = lookup(reviewers.value, "users", [])
    }
  }

  # Wait timer for development
  wait_timer = var.development_environment_wait_timer

  # Prevent self-review
  prevent_self_review = var.development_environment_prevent_self_review
}

# Custom deployment branch policy for development
resource "github_repository_environment_deployment_policy" "development" {
  count           = var.create_development_environment ? 1 : 0
  repository      = data.github_repository.repo.name
  environment     = github_repository_environment.development[0].environment
  branch_pattern  = var.develop_branch_name
}

# Staging environment
resource "github_repository_environment" "staging" {
  count       = var.create_staging_environment ? 1 : 0
  repository  = data.github_repository.repo.name
  environment = var.staging_environment_name

  # Staging can be deployed from release branches
  deployment_branch_policy {
    protected_branches     = false
    custom_branch_policies = true
  }

  # Reviewers for staging deployments
  dynamic "reviewers" {
    for_each = var.staging_environment_reviewers
    content {
      teams = lookup(reviewers.value, "teams", [])
      users = lookup(reviewers.value, "users", [])
    }
  }

  # Wait timer for staging
  wait_timer = var.staging_environment_wait_timer

  # Prevent self-review
  prevent_self_review = var.staging_environment_prevent_self_review
}

# Custom deployment branch policy for staging
resource "github_repository_environment_deployment_policy" "staging" {
  count           = var.create_staging_environment ? 1 : 0
  repository      = data.github_repository.repo.name
  environment     = github_repository_environment.staging[0].environment
  branch_pattern  = "release/*"
}

# Production environment
resource "github_repository_environment" "production" {
  count       = var.create_production_environment ? 1 : 0
  repository  = data.github_repository.repo.name
  environment = var.production_environment_name

  # Production can only be deployed from main branch
  deployment_branch_policy {
    protected_branches     = true
    custom_branch_policies = false
  }

  # Strict reviewers for production deployments
  dynamic "reviewers" {
    for_each = var.production_environment_reviewers
    content {
      teams = lookup(reviewers.value, "teams", [])
      users = lookup(reviewers.value, "users", [])
    }
  }

  # Wait timer for production
  wait_timer = var.production_environment_wait_timer

  # Prevent self-review in production
  prevent_self_review = var.production_environment_prevent_self_review
}

# Repository webhooks for GitFlow automation
resource "github_repository_webhook" "gitflow_automation" {
  count      = var.enable_gitflow_webhooks ? 1 : 0
  repository = data.github_repository.repo.name

  configuration {
    url          = var.webhook_url
    content_type = var.webhook_content_type
    insecure_ssl = var.webhook_insecure_ssl
    secret       = var.webhook_secret
  }

  active = var.webhook_active

  events = var.webhook_events
}

# Repository topics for discoverability
resource "github_repository" "topics" {
  count = var.add_repository_topics ? 1 : 0
  name  = data.github_repository.repo.name

  topics = concat(
    data.github_repository.repo.topics,
    var.repository_topics
  )

  lifecycle {
    ignore_changes = [
      # Only manage topics, ignore other attributes
      description,
      homepage_url,
      visibility,
      has_issues,
      has_projects,
      has_wiki,
      allow_merge_commit,
      allow_squash_merge,
      allow_rebase_merge,
      delete_branch_on_merge,
      auto_init,
      gitignore_template,
      license_template,
    ]
  }
}

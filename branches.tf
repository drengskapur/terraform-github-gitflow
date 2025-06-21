###############################################################################
# Ruleset factory – one entry per logical branch class
###############################################################################
locals {
  branch_rulesets = {
    main = merge(
      {
        include = [var.main_branch_name]
        enforcement = "active"
        required_reviews = 2
        strict_checks   = true
        require_linear_history = true
        require_signed_commits = var.main_branch_require_signed_commits
        status_checks = var.main_branch_status_checks
      },
      var.main_branch_overrides
    )

    develop = var.enable_develop_branch ? merge(
      {
        include = [var.develop_branch_name]
        enforcement = "active"
        required_reviews = 1
        strict_checks   = false
        require_linear_history = false
        require_signed_commits = var.develop_branch_require_signed_commits
        status_checks = var.develop_branch_status_checks
      },
      var.develop_branch_overrides
    ) : null

    feature = var.enable_feature_branches ? {
      include = ["feature/*", "bugfix/*"]
      enforcement = "active"
      required_reviews = 0
      strict_checks   = false
      require_linear_history = false
      require_signed_commits = false
      name_pattern    = "^((feature)|(bugfix))\\/[-0-9A-Za-z_]+$"
      status_checks = []
    } : null

    release = var.enable_release_branches ? {
      include = ["release/*"]
      enforcement = "active"
      required_reviews = 2
      strict_checks   = true
      require_linear_history = true
      require_signed_commits = var.release_branch_require_signed_commits
      name_pattern    = "^release\\/v[0-9]+\\.[0-9]+\\.[0-9]+$"
      status_checks = var.release_branch_status_checks
    } : null

    hotfix = var.enable_hotfix_branches ? {
      include = ["hotfix/*"]
      enforcement = "active"
      required_reviews = 1
      strict_checks   = true
      require_linear_history = true
      require_signed_commits = var.hotfix_branch_require_signed_commits
      name_pattern    = "^hotfix\\/v[0-9]+\\.[0-9]+\\.[0-9]+$"
      status_checks = var.hotfix_branch_status_checks
    } : null
  }

  # prune nulls when a class is disabled
  pruned_branch_rulesets = { for k, v in local.branch_rulesets : k => v if v != null }
}

resource "github_repository_ruleset" "branches" {
  for_each   = local.pruned_branch_rulesets

  name        = "${each.key}-ruleset"
  repository  = github_repository.this.name
  target      = "branch"
  enforcement = each.value.enforcement

  conditions {
    ref_name {
      include = each.value.include
      exclude = []
    }
  }

  rules {
    creation                      = false
    deletion                      = true
    non_fast_forward              = true
    update                        = true
    required_linear_history       = lookup(each.value, "require_linear_history", false)
    required_signatures           = lookup(each.value, "require_signed_commits", false)

    # reviews
    pull_request {
      required_approving_review_count = each.value.required_reviews
    }

    # status checks
    dynamic "required_status_checks" {
      for_each = length(lookup(each.value, "status_checks", [])) > 0 ? [1] : []
      content {
        strict_required_status_checks_policy = lookup(each.value, "strict_checks", false)

        dynamic "required_check" {
          for_each = each.value.status_checks
          content {
            context        = required_check.value
            integration_id = null
          }
        }
      }
    }

    # branch/commit patterns
    dynamic "branch_name_pattern" {
      for_each = lookup(each.value, "name_pattern", null) != null ? [1] : []
      content {
        name     = "Branch naming"
        operator = "regex"
        pattern  = each.value.name_pattern
      }
    }

    commit_message_pattern {
      name     = "Conventional commits"
      operator = "regex"
      pattern  = var.conventional_commit_regex
    }
  }

  # emergency bypasses
  dynamic "bypass_actors" {
    for_each = var.bypass_actors
    content {
      actor_id    = bypass_actors.value.id
      actor_type  = bypass_actors.value.type
      bypass_mode = bypass_actors.value.mode
    }
  }
} 
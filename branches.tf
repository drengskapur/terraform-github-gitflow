###############################################################################
# Ruleset factory – one entry per logical branch class
###############################################################################
locals {
  branch_rulesets = {
    main = merge(
      {
        include                = ["refs/heads/${var.main_branch_name}"]
        enforcement            = "active"
        required_reviews       = 2
        strict_checks          = true
        require_linear_history = true
        require_signed_commits = var.main_branch_require_signed_commits
        status_checks          = var.main_branch_status_checks
        ordinal                = 1
      },
      var.main_branch_overrides
    )

    develop = var.enable_gitflow && var.enable_develop_branch ? merge(
      {
        include                = ["refs/heads/${var.develop_branch_name}"]
        enforcement            = "active"
        required_reviews       = 1
        strict_checks          = false
        require_linear_history = false
        require_signed_commits = var.develop_branch_require_signed_commits
        status_checks          = var.develop_branch_status_checks
        ordinal                = 10
      },
      var.develop_branch_overrides
    ) : null

    feature = var.enable_gitflow && var.enable_feature_branches ? {
      include                = ["refs/heads/feature/*", "refs/heads/bugfix/*"]
      enforcement            = "active"
      required_reviews       = 0
      strict_checks          = false
      require_linear_history = false
      require_signed_commits = false
      name_pattern           = "^((feature)|(bugfix))\\/[-0-9A-Za-z_]+$"
      status_checks          = []
      ordinal                = 20
    } : null

    release = var.enable_gitflow && var.enable_release_branches ? {
      include                = ["refs/heads/release/*"]
      enforcement            = "active"
      required_reviews       = 2
      strict_checks          = true
      require_linear_history = true
      require_signed_commits = var.release_branch_require_signed_commits
      name_pattern           = "^release\\/v[0-9]+\\.[0-9]+\\.[0-9]+(-[0-9A-Za-z.-]+)?$"
      status_checks          = var.release_branch_status_checks
      ordinal                = 30
    } : null

    hotfix = var.enable_gitflow && var.enable_hotfix_branches ? {
      include                = ["refs/heads/hotfix/*"]
      enforcement            = "active"
      required_reviews       = 1
      strict_checks          = true
      require_linear_history = true
      require_signed_commits = var.hotfix_branch_require_signed_commits
      name_pattern           = "^hotfix\\/v[0-9]+\\.[0-9]+\\.[0-9]+(-[0-9A-Za-z.-]+)?$"
      status_checks          = var.hotfix_branch_status_checks
      ordinal                = 40
    } : null
  }

  # prune nulls when a class is disabled
  pruned_branch_rulesets = { for k, v in local.branch_rulesets : k => v if v != null }
}

resource "github_repository_ruleset" "branches" {
  for_each = local.pruned_branch_rulesets

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
    creation                = false
    deletion                = true
    non_fast_forward        = true
    update                  = true
    required_linear_history = lookup(each.value, "require_linear_history", false)
    required_signatures     = lookup(each.value, "require_signed_commits", false)

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

    dynamic "commit_message_pattern" {
      for_each = var.conventional_commit_regex != "" ? [1] : []
      content {
        name     = "Conventional commits"
        operator = "regex"
        pattern  = var.conventional_commit_regex
      }
    }

    # Commit author email pattern (if specified)
    dynamic "commit_author_email_pattern" {
      for_each = var.commit_author_email_pattern != "" ? [1] : []
      content {
        name     = "Email required"
        operator = "regex"
        pattern  = var.commit_author_email_pattern
      }
    }

    # TODO: Required workflows are not yet supported by the Terraform GitHub provider
    # See: https://github.com/integrations/terraform-provider-github/issues/2394
    # When support is added, this would enable required GitHub Actions workflows:
    #
    # dynamic "required_workflows" {
    #   for_each = var.required_workflows
    #   content {
    #     path         = required_workflows.value.path
    #     repository   = required_workflows.value.repository
    #     ref          = required_workflows.value.ref
    #   }
    # }
  }

  # emergency bypasses
  dynamic "bypass_actors" {
    for_each = var.bypass_actors
    content {
      actor_id    = bypass_actors.value.actor_id
      actor_type  = bypass_actors.value.actor_type
      bypass_mode = bypass_actors.value.bypass_mode
    }
  }
}

###############################################################################
# Tag protection ruleset for release tags
###############################################################################

resource "github_repository_ruleset" "tags" {
  count       = var.enable_tag_protection ? 1 : 0
  name        = "tag-protection"
  repository  = github_repository.this.name
  target      = "tag"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["refs/tags/v*", "refs/tags/V*"]
      exclude = []
    }
  }

  rules {
    creation = false
    deletion = true
    update   = true
  }

  dynamic "bypass_actors" {
    for_each = var.bypass_actors
    content {
      actor_id    = bypass_actors.value.actor_id
      actor_type  = bypass_actors.value.actor_type
      bypass_mode = bypass_actors.value.bypass_mode
    }
  }
}

###############################################################################
# Push rules for file restrictions
###############################################################################

###############################################################################
# Push rules for file restrictions
###############################################################################

# TODO: Push rulesets are supported by GitHub but specific push rules are not yet
# implemented in the Terraform GitHub provider. The provider supports target = "push"
# but not the specific rule types like file_path_restriction, file_extension_restriction, etc.
# See: https://github.com/integrations/terraform-provider-github/issues/2394
#
# When support is added, this would enable blocking large files and restricted
# file extensions across the entire repository and fork network:
#
# resource "github_repository_ruleset" "push_rules" {
#   count       = var.enable_push_rules ? 1 : 0
#   name        = "push-restrictions"
#   repository  = github_repository.this.name
#   target      = "push"
#   enforcement = "active"
#
#   rules {
#     # File path restrictions
#     dynamic "file_path_restriction" {
#       for_each = length(var.restricted_file_paths) > 0 ? [1] : []
#       content {
#         restricted_file_paths = var.restricted_file_paths
#       }
#     }
#
#     # File extension restrictions
#     dynamic "file_extension_restriction" {
#       for_each = length(var.restricted_file_extensions) > 0 ? [1] : []
#       content {
#         restricted_file_extensions = var.restricted_file_extensions
#       }
#     }
#
#     # File size restrictions
#     dynamic "max_file_size" {
#       for_each = var.max_file_size_mb > 0 ? [1] : []
#       content {
#         max_file_size = var.max_file_size_mb
#       }
#     }
#
#     # File path length restrictions
#     dynamic "max_file_path_length" {
#       for_each = var.max_file_path_length > 0 ? [1] : []
#       content {
#         max_file_path_length = var.max_file_path_length
#       }
#     }
#   }
#
#   dynamic "bypass_actors" {
#     for_each = var.bypass_actors
#     content {
#       actor_id    = bypass_actors.value.actor_id
#       actor_type  = bypass_actors.value.actor_type
#       bypass_mode = bypass_actors.value.bypass_mode
#     }
#   }
# }

# Placeholder for when push rulesets are fully supported
locals {
  push_rules_note = "Push rulesets will be enabled when Terraform GitHub provider adds support for specific push rule types"
}

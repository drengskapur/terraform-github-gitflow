# =============================================================================
# REPOSITORY INFORMATION
# =============================================================================

output "repository_name" {
  description = "Name of the repository"
  value       = data.github_repository.repo.name
}

output "repository_full_name" {
  description = "Full name of the repository"
  value       = data.github_repository.repo.full_name
}

output "repository_html_url" {
  description = "HTML URL of the repository"
  value       = data.github_repository.repo.html_url
}

output "repository_clone_url" {
  description = "Clone URL of the repository"
  value       = data.github_repository.repo.http_clone_url
}

output "repository_ssh_clone_url" {
  description = "SSH clone URL of the repository"
  value       = data.github_repository.repo.ssh_clone_url
}

output "repository_default_branch" {
  description = "Default branch of the repository"
  value       = data.github_repository.repo.default_branch
}

# =============================================================================
# BRANCH INFORMATION
# =============================================================================

output "main_branch_name" {
  description = "Name of the main branch"
  value       = var.main_branch_name
}

output "develop_branch_name" {
  description = "Name of the develop branch"
  value       = var.develop_branch_name
}

output "develop_branch_created" {
  description = "Whether the develop branch was created"
  value       = var.create_develop_branch
}

output "develop_branch_ref" {
  description = "Git reference for the develop branch"
  value       = var.create_develop_branch ? github_branch.develop[0].ref : null
}

output "develop_set_as_default" {
  description = "Whether develop branch is set as default"
  value       = var.set_develop_as_default
}

# =============================================================================
# RULESETS INFORMATION
# =============================================================================

output "main_branch_ruleset" {
  description = "Main branch ruleset information"
  value = {
    id          = github_repository_ruleset.main_branch.id
    name        = github_repository_ruleset.main_branch.name
    enforcement = github_repository_ruleset.main_branch.enforcement
    node_id     = github_repository_ruleset.main_branch.node_id
  }
}

output "develop_branch_ruleset" {
  description = "Develop branch ruleset information"
  value = var.create_develop_branch ? {
    id          = github_repository_ruleset.develop_branch[0].id
    name        = github_repository_ruleset.develop_branch[0].name
    enforcement = github_repository_ruleset.develop_branch[0].enforcement
    node_id     = github_repository_ruleset.develop_branch[0].node_id
  } : null
}

output "feature_branch_ruleset" {
  description = "Feature branch ruleset information"
  value = var.enable_feature_branch_protection ? {
    id          = github_repository_ruleset.feature_branches[0].id
    name        = github_repository_ruleset.feature_branches[0].name
    enforcement = github_repository_ruleset.feature_branches[0].enforcement
    node_id     = github_repository_ruleset.feature_branches[0].node_id
    patterns    = var.feature_branch_patterns
  } : null
}

output "release_branch_ruleset" {
  description = "Release branch ruleset information"
  value = var.enable_release_branch_protection ? {
    id          = github_repository_ruleset.release_branches[0].id
    name        = github_repository_ruleset.release_branches[0].name
    enforcement = github_repository_ruleset.release_branches[0].enforcement
    node_id     = github_repository_ruleset.release_branches[0].node_id
    patterns    = var.release_branch_patterns
  } : null
}

output "hotfix_branch_ruleset" {
  description = "Hotfix branch ruleset information"
  value = var.enable_hotfix_branch_protection ? {
    id          = github_repository_ruleset.hotfix_branches[0].id
    name        = github_repository_ruleset.hotfix_branches[0].name
    enforcement = github_repository_ruleset.hotfix_branches[0].enforcement
    node_id     = github_repository_ruleset.hotfix_branches[0].node_id
    patterns    = var.hotfix_branch_patterns
  } : null
}

output "push_restrictions_ruleset" {
  description = "Push restrictions ruleset information"
  value = var.enable_push_restrictions ? {
    id          = github_repository_ruleset.push_restrictions[0].id
    name        = github_repository_ruleset.push_restrictions[0].name
    enforcement = github_repository_ruleset.push_restrictions[0].enforcement
    node_id     = github_repository_ruleset.push_restrictions[0].node_id
  } : null
}

output "tag_protection_ruleset" {
  description = "Tag protection ruleset information"
  value = var.enable_tag_protection ? {
    id          = github_repository_ruleset.tag_protection[0].id
    name        = github_repository_ruleset.tag_protection[0].name
    enforcement = github_repository_ruleset.tag_protection[0].enforcement
    node_id     = github_repository_ruleset.tag_protection[0].node_id
    patterns    = var.tag_protection_patterns
  } : null
}

output "all_rulesets" {
  description = "Summary of all configured rulesets"
  value = {
    main_branch     = github_repository_ruleset.main_branch.name
    develop_branch  = var.create_develop_branch ? github_repository_ruleset.develop_branch[0].name : null
    feature_branch  = var.enable_feature_branch_protection ? github_repository_ruleset.feature_branches[0].name : null
    release_branch  = var.enable_release_branch_protection ? github_repository_ruleset.release_branches[0].name : null
    hotfix_branch   = var.enable_hotfix_branch_protection ? github_repository_ruleset.hotfix_branches[0].name : null
    push_restrictions = var.enable_push_restrictions ? github_repository_ruleset.push_restrictions[0].name : null
    tag_protection  = var.enable_tag_protection ? github_repository_ruleset.tag_protection[0].name : null
  }
}

# =============================================================================
# ENVIRONMENT INFORMATION
# =============================================================================

output "development_environment" {
  description = "Development environment information"
  value = var.create_development_environment ? {
    name        = github_repository_environment.development[0].environment
    id          = github_repository_environment.development[0].id
    wait_timer  = github_repository_environment.development[0].wait_timer
  } : null
}

output "staging_environment" {
  description = "Staging environment information"
  value = var.create_staging_environment ? {
    name        = github_repository_environment.staging[0].environment
    id          = github_repository_environment.staging[0].id
    wait_timer  = github_repository_environment.staging[0].wait_timer
  } : null
}

output "production_environment" {
  description = "Production environment information"
  value = var.create_production_environment ? {
    name        = github_repository_environment.production[0].environment
    id          = github_repository_environment.production[0].id
    wait_timer  = github_repository_environment.production[0].wait_timer
  } : null
}

output "environments_summary" {
  description = "Summary of all configured environments"
  value = {
    development = var.create_development_environment ? var.development_environment_name : null
    staging     = var.create_staging_environment ? var.staging_environment_name : null
    production  = var.create_production_environment ? var.production_environment_name : null
  }
}

# =============================================================================
# SECURITY FEATURES
# =============================================================================

output "dependabot_security_updates" {
  description = "Dependabot security updates configuration"
  value = var.enable_dependabot_security_updates ? {
    enabled    = github_repository_dependabot_security_updates.main[0].enabled
    repository = github_repository_dependabot_security_updates.main[0].repository
  } : null
}

# =============================================================================
# WEBHOOK INFORMATION
# =============================================================================

output "gitflow_webhook" {
  description = "GitFlow automation webhook information"
  value = var.enable_gitflow_webhooks ? {
    id     = github_repository_webhook.gitflow_automation[0].id
    url    = github_repository_webhook.gitflow_automation[0].url
    active = github_repository_webhook.gitflow_automation[0].active
    events = github_repository_webhook.gitflow_automation[0].events
  } : null
}

# =============================================================================
# PROTECTION SUMMARY
# =============================================================================

output "branch_protection_summary" {
  description = "Summary of branch protection configuration"
  value = {
    main_branch = {
      name                    = var.main_branch_name
      required_reviews        = var.main_branch_required_reviews
      require_code_owners     = var.main_branch_require_code_owner_reviews
      dismiss_stale_reviews   = var.main_branch_dismiss_stale_reviews
      require_linear_history  = var.main_branch_require_linear_history
      require_signed_commits  = var.main_branch_require_signed_commits
      status_checks_count     = length(var.main_branch_status_checks)
    }
    develop_branch = var.create_develop_branch ? {
      name                    = var.develop_branch_name
      required_reviews        = var.develop_branch_required_reviews
      require_code_owners     = var.develop_branch_require_code_owner_reviews
      dismiss_stale_reviews   = var.develop_branch_dismiss_stale_reviews
      require_linear_history  = var.develop_branch_require_linear_history
      status_checks_count     = length(var.develop_branch_status_checks)
    } : null
    feature_branches = var.enable_feature_branch_protection ? {
      patterns            = var.feature_branch_patterns
      required_reviews    = var.feature_branch_required_reviews
      require_pr          = var.feature_branch_require_pr
      status_checks_count = length(var.feature_branch_status_checks)
    } : null
    release_branches = var.enable_release_branch_protection ? {
      patterns                = var.release_branch_patterns
      required_reviews        = var.release_branch_required_reviews
      require_code_owners     = var.release_branch_require_code_owner_reviews
      require_linear_history  = var.release_branch_require_linear_history
      require_signed_commits  = var.release_branch_require_signed_commits
      status_checks_count     = length(var.release_branch_status_checks)
    } : null
    hotfix_branches = var.enable_hotfix_branch_protection ? {
      patterns                = var.hotfix_branch_patterns
      required_reviews        = var.hotfix_branch_required_reviews
      require_code_owners     = var.hotfix_branch_require_code_owner_reviews
      require_linear_history  = var.hotfix_branch_require_linear_history
      require_signed_commits  = var.hotfix_branch_require_signed_commits
      status_checks_count     = length(var.hotfix_branch_status_checks)
    } : null
  }
}

# =============================================================================
# GITFLOW CONFIGURATION SUMMARY
# =============================================================================

output "gitflow_configuration" {
  description = "Complete GitFlow configuration summary"
  value = {
    repository = {
      name         = data.github_repository.repo.name
      full_name    = data.github_repository.repo.full_name
      html_url     = data.github_repository.repo.html_url
      default_branch = data.github_repository.repo.default_branch
    }
    branches = {
      main    = var.main_branch_name
      develop = var.develop_branch_name
    }
    merge_strategies = {
      allow_merge_commit = var.allow_merge_commit
      allow_squash_merge = var.allow_squash_merge
      allow_rebase_merge = var.allow_rebase_merge
    }
    security_features = {
      vulnerability_alerts                    = var.enable_vulnerability_alerts
      advanced_security                       = var.enable_advanced_security
      secret_scanning                         = var.enable_secret_scanning
      secret_scanning_push_protection         = var.enable_secret_scanning_push_protection
      dependabot_security_updates             = var.enable_dependabot_security_updates
    }
    rulesets_enabled = {
      main_branch           = true
      develop_branch        = var.create_develop_branch
      feature_branches      = var.enable_feature_branch_protection
      release_branches      = var.enable_release_branch_protection
      hotfix_branches       = var.enable_hotfix_branch_protection
      push_restrictions     = var.enable_push_restrictions
      tag_protection        = var.enable_tag_protection
    }
    environments_enabled = {
      development = var.create_development_environment
      staging     = var.create_staging_environment
      production  = var.create_production_environment
    }
      automation = {
        webhooks_enabled = var.enable_gitflow_webhooks
        topics_added     = var.add_repository_topics
    }
  }
}

# =============================================================================
# USEFUL URLS AND REFERENCES
# =============================================================================

output "repository_urls" {
  description = "Useful URLs for repository management"
  value = {
    repository    = data.github_repository.repo.html_url
    settings      = "${data.github_repository.repo.html_url}/settings"
    branches      = "${data.github_repository.repo.html_url}/settings/branches"
    rulesets      = "${data.github_repository.repo.html_url}/settings/rules"
    environments  = "${data.github_repository.repo.html_url}/settings/environments"
    actions       = "${data.github_repository.repo.html_url}/actions"
    security      = "${data.github_repository.repo.html_url}/security"
    insights      = "${data.github_repository.repo.html_url}/pulse"
  }
}

# =============================================================================
# COMPLIANCE AND GOVERNANCE
# =============================================================================

output "compliance_status" {
  description = "GitFlow compliance and governance status"
  value = {
    gitflow_compliant = {
      has_main_branch      = true
      has_develop_branch   = var.create_develop_branch
      main_protected       = true
      develop_protected    = var.create_develop_branch
      merge_commit_allowed = var.allow_merge_commit
      linear_history_main  = var.main_branch_require_linear_history
    }
    security_compliant = {
      vulnerability_alerts       = var.enable_vulnerability_alerts
      secret_scanning            = var.enable_secret_scanning
      dependabot_security_updates = var.enable_dependabot_security_updates
      signed_commits_main        = var.main_branch_require_signed_commits
      code_owner_reviews         = var.main_branch_require_code_owner_reviews
    }
    review_requirements = {
      main_branch_reviews    = var.main_branch_required_reviews
      develop_branch_reviews = var.develop_branch_required_reviews
      release_branch_reviews = var.release_branch_required_reviews
      hotfix_branch_reviews  = var.hotfix_branch_required_reviews
    }
  }
}

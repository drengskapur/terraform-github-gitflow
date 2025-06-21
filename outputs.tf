###############################################################################
# REPOSITORY INFORMATION
###############################################################################

output "repository_html_url" {
  value       = github_repository.this.html_url
  description = "Link to the GitHub repository."
}

output "repository_clone_url" {
  value       = github_repository.this.http_clone_url
  description = "Clone URL for the repository."
}

output "repository_ssh_clone_url" {
  value       = github_repository.this.ssh_clone_url
  description = "SSH clone URL for the repository."
}

###############################################################################
# BRANCH INFORMATION
###############################################################################

output "main_branch_name" {
  value       = var.main_branch_name
  description = "Name of the main branch."
}

output "develop_branch_name" {
  value       = var.enable_gitflow && var.enable_develop_branch ? var.develop_branch_name : null
  description = "Name of the develop branch (null if disabled)."
}

###############################################################################
# RULESET INFORMATION
###############################################################################

output "main_branch_ruleset_id" {
  value       = var.enable_branch_protection_rulesets ? github_repository_ruleset.branches["main"].id : null
  description = "Ruleset ID for the main branch (null if rulesets disabled)."
}

output "develop_branch_ruleset_id" {
  value       = var.enable_branch_protection_rulesets && var.enable_gitflow && var.enable_develop_branch ? github_repository_ruleset.branches["develop"].id : null
  description = "Ruleset ID for the develop branch (null if disabled)."
}

output "tag_protection_ruleset_id" {
  value       = var.enable_branch_protection_rulesets && var.enable_tag_protection ? one(github_repository_ruleset.tags[*].id) : null
  description = "Ruleset ID for tag protection (null if disabled)."
}

output "push_rules_ruleset_id" {
  value       = null # Push rulesets not yet supported by Terraform GitHub provider
  description = "Ruleset ID for push restrictions (not yet supported by provider)."
}

output "branch_rulesets" {
  value = var.enable_branch_protection_rulesets ? {
    for k, v in github_repository_ruleset.branches : k => {
      id          = v.id
      name        = v.name
      enforcement = v.enforcement
    }
  } : {}
  description = "Map of all branch rulesets with their IDs and enforcement status."
}

###############################################################################
# ENVIRONMENT INFORMATION
###############################################################################

output "environments" {
  value = {
    for k, v in github_repository_environment.this : k => {
      name       = v.environment
      html_url   = "https://github.com/${var.github_owner}/${var.repository_name}/settings/environments/${v.environment}"
      wait_timer = v.wait_timer
    }
  }
  description = "Map of all environments with their URLs and settings."
}

###############################################################################
# SECURITY FEATURES STATUS
###############################################################################

output "security_features" {
  value = {
    advanced_security               = var.enable_advanced_security
    secret_scanning                 = var.enable_secret_scanning
    secret_scanning_push_protection = var.enable_secret_scanning_push_protection
    dependabot_security_updates     = var.enable_dependabot_security_updates
    vulnerability_alerts            = true
  }
  description = "Status of all security features enabled on the repository."
}

###############################################################################
# GITFLOW CONFIGURATION SUMMARY
###############################################################################

output "gitflow_configuration" {
  value = {
    enabled        = var.enable_gitflow
    main_branch    = var.main_branch_name
    develop_branch = var.enable_gitflow && var.enable_develop_branch ? var.develop_branch_name : null

    branch_types = {
      feature_branches = var.enable_gitflow && var.enable_feature_branches
      release_branches = var.enable_gitflow && var.enable_release_branches
      hotfix_branches  = var.enable_gitflow && var.enable_hotfix_branches
    }

    environments = {
      development = var.enable_gitflow && var.enable_dev_environment
      staging     = var.enable_gitflow && var.enable_stage_environment
      production  = var.enable_prod_environment
    }

    protection_features = {
      tag_protection     = var.enable_tag_protection
      push_rules         = var.enable_push_rules
      codeowners_file    = var.enable_codeowners_file
      required_workflows = length(var.required_workflows) > 0
      email_pattern      = var.commit_author_email_pattern != ""
    }

    webhook_enabled = var.enable_webhook
  }
  description = "Complete GitFlow configuration summary."
}

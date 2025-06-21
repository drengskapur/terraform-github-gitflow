terraform {
  required_version = ">= 1.9.0"
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.6.0"
    }
  }
}

provider "github" {
  owner    = var.github_owner
  base_url = var.github_base_url      # leave null for github.com
  token    = var.github_token         # leave null → GITHUB_TOKEN env or gh auth
}

###############################################################################
# Core repository settings (sane defaults, fully overridable)
###############################################################################

resource "github_repository" "this" {
  name = var.repository_name

  allow_merge_commit     = var.repo_allow_merge_commit
  allow_rebase_merge     = var.repo_allow_rebase_merge
  allow_squash_merge     = var.repo_allow_squash_merge
  allow_auto_merge       = true
  allow_update_branch    = true
  delete_branch_on_merge = true

  visibility             = var.repository_visibility
  vulnerability_alerts   = true
  has_discussions        = true
  has_issues             = true
  has_wiki               = var.repo_has_wiki
  has_projects           = var.repo_has_projects

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
    ignore_changes = [topics, homepage_url, description] # managed elsewhere
  }
}

###############################################################################
# Optional develop branch (Git Flow)
###############################################################################

resource "github_branch" "develop" {
  for_each      = var.enable_develop_branch ? { dev = 1 } : {}
  repository    = github_repository.this.name
  branch        = var.develop_branch_name
  source_branch = var.main_branch_name
}

resource "github_branch_default" "develop" {
  for_each   = var.enable_develop_branch && var.set_develop_as_default ? { dev = 1 } : {}
  repository = github_repository.this.name
  branch     = var.develop_branch_name
  depends_on = [github_branch.develop]
}

###############################################################################
# Dependabot security updates for automated dependency management
###############################################################################

resource "github_repository_dependabot_security_updates" "this" {
  count      = var.enable_dependabot_security_updates ? 1 : 0
  repository = github_repository.this.name
  enabled    = true
}

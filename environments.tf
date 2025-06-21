###############################################################################
# GitHub Environments for GitFlow deployment workflows
###############################################################################

locals {
  envs = {
    dev = var.enable_gitflow && var.enable_dev_environment ? {
      name      = "development"
      branches  = [var.develop_branch_name]
      reviewers = var.dev_env_reviewers
      wait      = 0
    } : null

    stage = var.enable_gitflow && var.enable_stage_environment ? {
      name      = "staging"
      branches  = ["release/*"]
      reviewers = var.stage_env_reviewers
      wait      = 10
    } : null

    prod = var.enable_prod_environment ? {
      name      = "production"
      branches  = [var.main_branch_name]
      reviewers = var.prod_env_reviewers
      wait      = 30
    } : null
  }

  # prune nulls when an environment is disabled
  pruned_envs = { for k, v in local.envs : k => v if v != null }
}

resource "github_repository_environment" "this" {
  for_each    = local.pruned_envs
  repository  = github_repository.this.name
  environment = each.value.name

  wait_timer          = each.value.wait
  prevent_self_review = true

  deployment_branch_policy {
    protected_branches     = contains(each.value.branches, var.main_branch_name)
    custom_branch_policies = !contains(each.value.branches, var.main_branch_name)
  }

  # Note: GitHub API expects numeric user/team IDs, not usernames/team names
  # Reviewers are commented out until proper ID lookup is implemented
  # dynamic "reviewers" {
  #   for_each = length(each.value.reviewers) > 0 ? [1] : []
  #   content {
  #     users = each.value.reviewers  # Requires numeric user IDs
  #     teams = each.value.team_ids   # Requires numeric team IDs
  #   }
  # }
}

resource "github_repository_environment_deployment_policy" "branch_policy" {
  for_each       = local.pruned_envs
  repository     = github_repository.this.name
  environment    = github_repository_environment.this[each.key].environment
  branch_pattern = join(",", each.value.branches)
}

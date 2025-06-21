output "repository_name" {
  description = "Name of the repository"
  value       = data.github_repository.repo.name
}

output "repository_full_name" {
  description = "Full name of the repository"
  value       = data.github_repository.repo.full_name
}

output "main_branch_protection_id" {
  description = "ID of the main branch protection rule"
  value       = github_branch_protection.main.id
}

output "develop_branch_protection_id" {
  description = "ID of the develop branch protection rule"
  value       = github_branch_protection.develop.id
}

output "develop_branch_created" {
  description = "Whether the develop branch was created"
  value       = github_branch.develop.branch
}

output "branch_protection_summary" {
  description = "Summary of branch protection settings"
  value = {
    main = {
      pattern                        = github_branch_protection.main.pattern
      required_reviews              = var.main_branch_required_reviews
      require_linear_history        = github_branch_protection.main.require_linear_history
      require_conversation_resolution = github_branch_protection.main.require_conversation_resolution
      status_checks                 = var.main_branch_status_checks
    }
    develop = {
      pattern                        = github_branch_protection.develop.pattern
      required_reviews              = var.develop_branch_required_reviews
      require_linear_history        = github_branch_protection.develop.require_linear_history
      require_conversation_resolution = github_branch_protection.develop.require_conversation_resolution
      status_checks                 = var.develop_branch_status_checks
    }
  }
}

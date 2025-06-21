# =============================================================================
# PROVIDER CONFIGURATION
# =============================================================================

variable "github_token" {
  description = "GitHub Personal Access Token or OAuth token. Can also be set via GITHUB_TOKEN environment variable."
  type        = string
  default     = null
  sensitive   = true
}

variable "github_owner" {
  description = "GitHub organization or individual user account to manage. Can also be set via GITHUB_OWNER environment variable."
  type        = string
  default     = null
}

variable "github_base_url" {
  description = "GitHub base API endpoint. Required for GitHub Enterprise. Can also be set via GITHUB_BASE_URL environment variable."
  type        = string
  default     = null
}

variable "github_app_auth" {
  description = "Configuration for GitHub App authentication"
  type = object({
    id              = string
    installation_id = string
    pem_file        = string
  })
  default   = null
  sensitive = true
}

variable "github_write_delay_ms" {
  description = "Number of milliseconds to sleep between write operations to satisfy GitHub API rate limits"
  type        = number
  default     = 1000
  validation {
    condition     = var.github_write_delay_ms >= 0
    error_message = "Write delay must be a non-negative number."
  }
}

variable "github_read_delay_ms" {
  description = "Number of milliseconds to sleep between read operations to satisfy GitHub API rate limits"
  type        = number
  default     = 0
  validation {
    condition     = var.github_read_delay_ms >= 0
    error_message = "Read delay must be a non-negative number."
  }
}

variable "github_retry_delay_ms" {
  description = "Number of milliseconds to sleep between requests after an error response"
  type        = number
  default     = 1000
  validation {
    condition     = var.github_retry_delay_ms >= 0
    error_message = "Retry delay must be a non-negative number."
  }
}

variable "github_max_retries" {
  description = "Number of times to retry a request after receiving an error status code"
  type        = number
  default     = 3
  validation {
    condition     = var.github_max_retries >= 0
    error_message = "Max retries must be a non-negative number."
  }
}

variable "github_retryable_errors" {
  description = "List of HTTP status codes that should trigger a retry"
  type        = list(number)
  default     = [500, 502, 503, 504]
}

# =============================================================================
# CORE REPOSITORY CONFIGURATION
# =============================================================================

variable "repository_full_name" {
  description = "Full name of the repository (owner/repo-name)"
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+/[a-zA-Z0-9._-]+$", var.repository_full_name))
    error_message = "Repository full name must be in the format 'owner/repo-name'."
  }
}

variable "organization_name" {
  description = "Name of the GitHub organization (optional, for team/app configurations)"
  type        = string
  default     = null
}

# =============================================================================
# BRANCH CONFIGURATION
# =============================================================================

variable "main_branch_name" {
  description = "Name of the main/production branch"
  type        = string
  default     = "main"
}

variable "develop_branch_name" {
  description = "Name of the develop/integration branch"
  type        = string
  default     = "develop"
}

variable "create_develop_branch" {
  description = "Whether to create the develop branch if it doesn't exist"
  type        = bool
  default     = true
}

variable "set_develop_as_default" {
  description = "Whether to set develop as the default branch (GitFlow best practice)"
  type        = bool
  default     = true
}

# =============================================================================
# REPOSITORY SETTINGS
# =============================================================================

variable "configure_repository_settings" {
  description = "Whether to configure repository settings for GitFlow"
  type        = bool
  default     = true
}

variable "allow_merge_commit" {
  description = "Allow merge commits (required for GitFlow)"
  type        = bool
  default     = true
}

variable "allow_squash_merge" {
  description = "Allow squash merging (flexible for feature branches)"
  type        = bool
  default     = true
}

variable "allow_rebase_merge" {
  description = "Allow rebase merging"
  type        = bool
  default     = true
}

variable "delete_branch_on_merge" {
  description = "Automatically delete head branches after PR merge"
  type        = bool
  default     = true
}

variable "allow_auto_merge" {
  description = "Allow auto-merge for pull requests"
  type        = bool
  default     = false
}

variable "allow_update_branch" {
  description = "Allow updating pull request branches"
  type        = bool
  default     = true
}

# Repository features
variable "enable_vulnerability_alerts" {
  description = "Enable vulnerability alerts"
  type        = bool
  default     = true
}

variable "enable_issues" {
  description = "Enable GitHub Issues"
  type        = bool
  default     = true
}

variable "enable_projects" {
  description = "Enable GitHub Projects"
  type        = bool
  default     = true
}

variable "enable_wiki" {
  description = "Enable GitHub Wiki"
  type        = bool
  default     = false
}

variable "enable_discussions" {
  description = "Enable GitHub Discussions"
  type        = bool
  default     = false
}

# Security features
variable "enable_advanced_security" {
  description = "Enable GitHub Advanced Security features"
  type        = bool
  default     = false
}

variable "enable_secret_scanning" {
  description = "Enable secret scanning"
  type        = bool
  default     = true
}

variable "enable_secret_scanning_push_protection" {
  description = "Enable secret scanning push protection"
  type        = bool
  default     = true
}

variable "enable_dependabot_security_updates" {
  description = "Enable Dependabot security updates"
  type        = bool
  default     = true
}

# =============================================================================
# MAIN BRANCH PROTECTION (PRODUCTION)
# =============================================================================

variable "main_branch_ruleset_name" {
  description = "Name of the main branch ruleset"
  type        = string
  default     = "Protect Main Branch"
}

variable "main_branch_enforcement" {
  description = "Enforcement level for main branch ruleset"
  type        = string
  default     = "active"
  validation {
    condition     = contains(["disabled", "active", "evaluate"], var.main_branch_enforcement)
    error_message = "Enforcement must be one of: disabled, active, evaluate."
  }
}

variable "main_branch_allow_updates" {
  description = "Allow updates to main branch"
  type        = bool
  default     = false
}

variable "main_branch_require_linear_history" {
  description = "Require linear history on main branch"
  type        = bool
  default     = true
}

variable "main_branch_required_reviews" {
  description = "Number of required approving reviews for main branch"
  type        = number
  default     = 2
  validation {
    condition     = var.main_branch_required_reviews >= 1 && var.main_branch_required_reviews <= 6
    error_message = "Required reviews must be between 1 and 6."
  }
}

variable "main_branch_dismiss_stale_reviews" {
  description = "Dismiss stale reviews when new commits are pushed to main branch"
  type        = bool
  default     = true
}

variable "main_branch_require_code_owner_reviews" {
  description = "Require code owner reviews for main branch"
  type        = bool
  default     = true
}

variable "main_branch_require_last_push_approval" {
  description = "Require approval from someone other than the last pusher"
  type        = bool
  default     = true
}

variable "main_branch_require_conversation_resolution" {
  description = "Require conversation resolution before merging"
  type        = bool
  default     = true
}

variable "main_branch_status_checks" {
  description = "List of required status checks for main branch"
  type = list(object({
    context        = string
    integration_id = optional(number)
  }))
  default = []
}

variable "main_branch_strict_status_checks" {
  description = "Require branches to be up to date before merging"
  type        = bool
  default     = true
}

variable "main_branch_require_signed_commits" {
  description = "Require signed commits on main branch"
  type        = bool
  default     = false
}

# Pattern enforcement for main branch
variable "main_branch_commit_message_pattern" {
  description = "Regex pattern for commit messages on main branch"
  type        = string
  default     = null
  # Example: "^(feat|fix|docs|style|refactor|test|chore)(\\(.+\\))?: .{1,50}"
}

variable "main_branch_commit_author_email_pattern" {
  description = "Regex pattern for commit author emails on main branch"
  type        = string
  default     = null
  # Example: "^[a-zA-Z0-9._%+-]+@(company\\.com|users\\.noreply\\.github\\.com)$"
}

variable "main_branch_committer_email_pattern" {
  description = "Regex pattern for committer emails on main branch"
  type        = string
  default     = null
}

variable "main_branch_name_pattern" {
  description = "Regex pattern for branch names (not typically used for main)"
  type        = string
  default     = null
}

variable "main_branch_tag_name_pattern" {
  description = "Regex pattern for tag names on main branch"
  type        = string
  default     = null
  # Example: "^v[0-9]+\\.[0-9]+\\.[0-9]+$"
}



variable "main_branch_bypass_actors" {
  description = "List of actors who can bypass main branch protection"
  type = list(object({
    actor_id    = number
    actor_type  = string # OrganizationAdmin, RepositoryRole, Team, Integration, DeployKey
    bypass_mode = string # always, pull_request
  }))
  default = []
}

# Advanced main branch protection features
variable "main_branch_required_deployments" {
  description = "List of deployment environments required before merging to main branch"
  type        = list(string)
  default     = []
}

variable "main_branch_enable_merge_queue" {
  description = "Enable merge queue for main branch"
  type        = bool
  default     = false
}

variable "main_branch_merge_queue_check_timeout" {
  description = "Maximum time for a required status check to report a conclusion (minutes)"
  type        = number
  default     = 60
  validation {
    condition     = var.main_branch_merge_queue_check_timeout >= 1 && var.main_branch_merge_queue_check_timeout <= 1440
    error_message = "Check timeout must be between 1 and 1440 minutes."
  }
}

variable "main_branch_merge_queue_grouping_strategy" {
  description = "Grouping strategy for merge queue"
  type        = string
  default     = "ALLGREEN"
  validation {
    condition     = contains(["ALLGREEN", "HEADGREEN"], var.main_branch_merge_queue_grouping_strategy)
    error_message = "Grouping strategy must be ALLGREEN or HEADGREEN."
  }
}

variable "main_branch_merge_queue_max_entries_to_build" {
  description = "Maximum number of queued pull requests requesting checks at the same time"
  type        = number
  default     = 5
  validation {
    condition     = var.main_branch_merge_queue_max_entries_to_build >= 0 && var.main_branch_merge_queue_max_entries_to_build <= 100
    error_message = "Max entries to build must be between 0 and 100."
  }
}

variable "main_branch_merge_queue_max_entries_to_merge" {
  description = "Maximum number of queued pull requests that can be merged at the same time"
  type        = number
  default     = 5
  validation {
    condition     = var.main_branch_merge_queue_max_entries_to_merge >= 0 && var.main_branch_merge_queue_max_entries_to_merge <= 100
    error_message = "Max entries to merge must be between 0 and 100."
  }
}

variable "main_branch_merge_queue_merge_method" {
  description = "Method to use when merging changes from queued pull requests"
  type        = string
  default     = "MERGE"
  validation {
    condition     = contains(["MERGE", "SQUASH", "REBASE"], var.main_branch_merge_queue_merge_method)
    error_message = "Merge method must be MERGE, SQUASH, or REBASE."
  }
}

variable "main_branch_merge_queue_min_entries_to_merge" {
  description = "Minimum number of PRs that will be merged together in a group"
  type        = number
  default     = 1
  validation {
    condition     = var.main_branch_merge_queue_min_entries_to_merge >= 1 && var.main_branch_merge_queue_min_entries_to_merge <= 100
    error_message = "Min entries to merge must be between 1 and 100."
  }
}

variable "main_branch_merge_queue_min_entries_to_merge_wait_minutes" {
  description = "Time merge queue should wait after the first PR is added for minimum group size to be met (minutes)"
  type        = number
  default     = 5
  validation {
    condition     = var.main_branch_merge_queue_min_entries_to_merge_wait_minutes >= 0 && var.main_branch_merge_queue_min_entries_to_merge_wait_minutes <= 1440
    error_message = "Min entries wait time must be between 0 and 1440 minutes."
  }
}

variable "main_branch_required_code_scanning" {
  description = "List of required code scanning tools for main branch"
  type = list(object({
    tool                      = string
    alerts_threshold          = string
    security_alerts_threshold = string
  }))
  default = []
  validation {
    condition = alltrue([
      for tool in var.main_branch_required_code_scanning :
      contains(["none", "errors", "errors_and_warnings", "all"], tool.alerts_threshold) &&
      contains(["none", "critical", "high_or_higher", "medium_or_higher", "all"], tool.security_alerts_threshold)
    ])
    error_message = "Invalid threshold values. alerts_threshold must be one of: none, errors, errors_and_warnings, all. security_alerts_threshold must be one of: none, critical, high_or_higher, medium_or_higher, all."
  }
}

variable "main_branch_status_checks_do_not_enforce_on_create" {
  description = "Allow repositories and branches to be created if a check would otherwise prohibit it"
  type        = bool
  default     = false
}

variable "main_branch_update_allows_fetch_and_merge" {
  description = "Branch can pull changes from its upstream repository (for forked repositories)"
  type        = bool
  default     = false
}

# =============================================================================
# DEVELOP BRANCH PROTECTION (INTEGRATION)
# =============================================================================

variable "develop_branch_ruleset_name" {
  description = "Name of the develop branch ruleset"
  type        = string
  default     = "Protect Develop Branch"
}

variable "develop_branch_enforcement" {
  description = "Enforcement level for develop branch ruleset"
  type        = string
  default     = "active"
  validation {
    condition     = contains(["disabled", "active", "evaluate"], var.develop_branch_enforcement)
    error_message = "Enforcement must be one of: disabled, active, evaluate."
  }
}

variable "develop_branch_prevent_force_push" {
  description = "Prevent force pushes to develop branch"
  type        = bool
  default     = true
}

variable "develop_branch_allow_updates" {
  description = "Allow updates to develop branch"
  type        = bool
  default     = true
}

variable "develop_branch_require_linear_history" {
  description = "Require linear history on develop branch (usually false for GitFlow)"
  type        = bool
  default     = false
}

variable "develop_branch_required_reviews" {
  description = "Number of required approving reviews for develop branch"
  type        = number
  default     = 1
  validation {
    condition     = var.develop_branch_required_reviews >= 0 && var.develop_branch_required_reviews <= 6
    error_message = "Required reviews must be between 0 and 6."
  }
}

variable "develop_branch_dismiss_stale_reviews" {
  description = "Dismiss stale reviews when new commits are pushed to develop branch"
  type        = bool
  default     = true
}

variable "develop_branch_require_code_owner_reviews" {
  description = "Require code owner reviews for develop branch"
  type        = bool
  default     = false
}

variable "develop_branch_require_last_push_approval" {
  description = "Require approval from someone other than the last pusher"
  type        = bool
  default     = false
}

variable "develop_branch_require_conversation_resolution" {
  description = "Require conversation resolution before merging"
  type        = bool
  default     = true
}

variable "develop_branch_status_checks" {
  description = "List of required status checks for develop branch"
  type = list(object({
    context        = string
    integration_id = optional(number)
  }))
  default = []
}

variable "develop_branch_strict_status_checks" {
  description = "Require branches to be up to date before merging"
  type        = bool
  default     = true
}

variable "develop_branch_commit_message_pattern" {
  description = "Regex pattern for commit messages on develop branch"
  type        = string
  default     = null
}

variable "develop_branch_bypass_actors" {
  description = "List of actors who can bypass develop branch protection"
  type = list(object({
    actor_id    = number
    actor_type  = string
    bypass_mode = string
  }))
  default = []
}

variable "develop_branch_required_deployments" {
  description = "List of deployment environments required before merging to develop branch"
  type        = list(string)
  default     = []
}

variable "develop_branch_enable_merge_queue" {
  description = "Enable merge queue for develop branch"
  type        = bool
  default     = false
}

variable "develop_branch_merge_queue_check_timeout" {
  description = "Maximum time for a required status check to report a conclusion (minutes)"
  type        = number
  default     = 60
  validation {
    condition     = var.develop_branch_merge_queue_check_timeout >= 1 && var.develop_branch_merge_queue_check_timeout <= 1440
    error_message = "Check timeout must be between 1 and 1440 minutes."
  }
}

variable "develop_branch_merge_queue_grouping_strategy" {
  description = "Grouping strategy for merge queue"
  type        = string
  default     = "ALLGREEN"
  validation {
    condition     = contains(["ALLGREEN", "HEADGREEN"], var.develop_branch_merge_queue_grouping_strategy)
    error_message = "Grouping strategy must be ALLGREEN or HEADGREEN."
  }
}

variable "develop_branch_merge_queue_max_entries_to_build" {
  description = "Maximum number of queued pull requests requesting checks at the same time"
  type        = number
  default     = 3
  validation {
    condition     = var.develop_branch_merge_queue_max_entries_to_build >= 0 && var.develop_branch_merge_queue_max_entries_to_build <= 100
    error_message = "Max entries to build must be between 0 and 100."
  }
}

variable "develop_branch_merge_queue_max_entries_to_merge" {
  description = "Maximum number of queued pull requests that can be merged at the same time"
  type        = number
  default     = 3
  validation {
    condition     = var.develop_branch_merge_queue_max_entries_to_merge >= 0 && var.develop_branch_merge_queue_max_entries_to_merge <= 100
    error_message = "Max entries to merge must be between 0 and 100."
  }
}

variable "develop_branch_merge_queue_merge_method" {
  description = "Method to use when merging changes from queued pull requests"
  type        = string
  default     = "MERGE"
  validation {
    condition     = contains(["MERGE", "SQUASH", "REBASE"], var.develop_branch_merge_queue_merge_method)
    error_message = "Merge method must be MERGE, SQUASH, or REBASE."
  }
}

variable "develop_branch_merge_queue_min_entries_to_merge" {
  description = "Minimum number of PRs that will be merged together in a group"
  type        = number
  default     = 1
  validation {
    condition     = var.develop_branch_merge_queue_min_entries_to_merge >= 1 && var.develop_branch_merge_queue_min_entries_to_merge <= 100
    error_message = "Min entries to merge must be between 1 and 100."
  }
}

variable "develop_branch_merge_queue_min_entries_to_merge_wait_minutes" {
  description = "Time merge queue should wait after the first PR is added for minimum group size to be met (minutes)"
  type        = number
  default     = 3
  validation {
    condition     = var.develop_branch_merge_queue_min_entries_to_merge_wait_minutes >= 0 && var.develop_branch_merge_queue_min_entries_to_merge_wait_minutes <= 1440
    error_message = "Min entries wait time must be between 0 and 1440 minutes."
  }
}

variable "develop_branch_required_code_scanning" {
  description = "List of required code scanning tools for develop branch"
  type = list(object({
    tool                      = string
    alerts_threshold          = string
    security_alerts_threshold = string
  }))
  default = []
  validation {
    condition = alltrue([
      for tool in var.develop_branch_required_code_scanning :
      contains(["none", "errors", "errors_and_warnings", "all"], tool.alerts_threshold) &&
      contains(["none", "critical", "high_or_higher", "medium_or_higher", "all"], tool.security_alerts_threshold)
    ])
    error_message = "Invalid threshold values. alerts_threshold must be one of: none, errors, errors_and_warnings, all. security_alerts_threshold must be one of: none, critical, high_or_higher, medium_or_higher, all."
  }
}

variable "develop_branch_status_checks_do_not_enforce_on_create" {
  description = "Allow repositories and branches to be created if a check would otherwise prohibit it"
  type        = bool
  default     = true
}

variable "develop_branch_update_allows_fetch_and_merge" {
  description = "Branch can pull changes from its upstream repository (for forked repositories)"
  type        = bool
  default     = true
}

# =============================================================================
# FEATURE BRANCH PROTECTION
# =============================================================================

variable "enable_feature_branch_protection" {
  description = "Enable protection rules for feature branches"
  type        = bool
  default     = true
}

variable "feature_branch_ruleset_name" {
  description = "Name of the feature branch ruleset"
  type        = string
  default     = "Feature Branch Guidelines"
}

variable "feature_branch_enforcement" {
  description = "Enforcement level for feature branch ruleset"
  type        = string
  default     = "active"
  validation {
    condition     = contains(["disabled", "active", "evaluate"], var.feature_branch_enforcement)
    error_message = "Enforcement must be one of: disabled, active, evaluate."
  }
}

variable "feature_branch_patterns" {
  description = "List of patterns that match feature branches"
  type        = list(string)
  default     = ["feature/*", "feat/*", "bugfix/*", "bug/*"]
}

variable "feature_branch_allow_deletion" {
  description = "Allow deletion of feature branches"
  type        = bool
  default     = true
}

variable "feature_branch_require_pr" {
  description = "Require pull requests for feature branches"
  type        = bool
  default     = false
}

variable "feature_branch_required_reviews" {
  description = "Number of required approving reviews for feature branches"
  type        = number
  default     = 1
  validation {
    condition     = var.feature_branch_required_reviews >= 0 && var.feature_branch_required_reviews <= 6
    error_message = "Required reviews must be between 0 and 6."
  }
}

variable "feature_branch_dismiss_stale_reviews" {
  description = "Dismiss stale reviews when new commits are pushed to feature branches"
  type        = bool
  default     = false
}

variable "feature_branch_require_conversation_resolution" {
  description = "Require conversation resolution before merging feature branches"
  type        = bool
  default     = false
}

variable "feature_branch_status_checks" {
  description = "List of required status checks for feature branches"
  type = list(object({
    context        = string
    integration_id = optional(number)
  }))
  default = []
}

variable "feature_branch_strict_status_checks" {
  description = "Require feature branches to be up to date before merging"
  type        = bool
  default     = false
}

variable "feature_branch_name_pattern" {
  description = "Regex pattern for feature branch names"
  type        = string
  default     = "^(feature|feat|bugfix|bug)/.+"
}

variable "feature_branch_commit_message_pattern" {
  description = "Regex pattern for commit messages on feature branches"
  type        = string
  default     = null
}

variable "feature_branch_bypass_actors" {
  description = "List of actors who can bypass feature branch protection"
  type = list(object({
    actor_id    = number
    actor_type  = string
    bypass_mode = string
  }))
  default = []
}

# =============================================================================
# RELEASE BRANCH PROTECTION
# =============================================================================

variable "enable_release_branch_protection" {
  description = "Enable protection rules for release branches"
  type        = bool
  default     = true
}

variable "release_branch_ruleset_name" {
  description = "Name of the release branch ruleset"
  type        = string
  default     = "Release Branch Protection"
}

variable "release_branch_enforcement" {
  description = "Enforcement level for release branch ruleset"
  type        = string
  default     = "active"
  validation {
    condition     = contains(["disabled", "active", "evaluate"], var.release_branch_enforcement)
    error_message = "Enforcement must be one of: disabled, active, evaluate."
  }
}

variable "release_branch_patterns" {
  description = "List of patterns that match release branches"
  type        = list(string)
  default     = ["release/*", "rel/*"]
}

variable "release_branch_allow_deletion" {
  description = "Allow deletion of release branches"
  type        = bool
  default     = false
}

variable "release_branch_prevent_force_push" {
  description = "Prevent force pushes to release branches"
  type        = bool
  default     = true
}

variable "release_branch_allow_updates" {
  description = "Allow updates to release branches"
  type        = bool
  default     = true
}

variable "release_branch_require_linear_history" {
  description = "Require linear history on release branches"
  type        = bool
  default     = true
}

variable "release_branch_required_reviews" {
  description = "Number of required approving reviews for release branches"
  type        = number
  default     = 2
  validation {
    condition     = var.release_branch_required_reviews >= 1 && var.release_branch_required_reviews <= 6
    error_message = "Required reviews must be between 1 and 6."
  }
}

variable "release_branch_dismiss_stale_reviews" {
  description = "Dismiss stale reviews when new commits are pushed to release branches"
  type        = bool
  default     = true
}

variable "release_branch_require_code_owner_reviews" {
  description = "Require code owner reviews for release branches"
  type        = bool
  default     = true
}

variable "release_branch_require_last_push_approval" {
  description = "Require approval from someone other than the last pusher"
  type        = bool
  default     = true
}

variable "release_branch_require_conversation_resolution" {
  description = "Require conversation resolution before merging release branches"
  type        = bool
  default     = true
}

variable "release_branch_status_checks" {
  description = "List of required status checks for release branches"
  type = list(object({
    context        = string
    integration_id = optional(number)
  }))
  default = []
}

variable "release_branch_strict_status_checks" {
  description = "Require release branches to be up to date before merging"
  type        = bool
  default     = true
}

variable "release_branch_name_pattern" {
  description = "Regex pattern for release branch names"
  type        = string
  default     = "^(release|rel)/v?[0-9]+\\.[0-9]+\\.[0-9]+.*"
}

variable "release_branch_commit_message_pattern" {
  description = "Regex pattern for commit messages on release branches"
  type        = string
  default     = null
}

variable "release_branch_require_signed_commits" {
  description = "Require signed commits on release branches"
  type        = bool
  default     = false
}

variable "release_branch_bypass_actors" {
  description = "List of actors who can bypass release branch protection"
  type = list(object({
    actor_id    = number
    actor_type  = string
    bypass_mode = string
  }))
  default = []
}

# =============================================================================
# HOTFIX BRANCH PROTECTION
# =============================================================================

variable "enable_hotfix_branch_protection" {
  description = "Enable protection rules for hotfix branches"
  type        = bool
  default     = true
}

variable "hotfix_branch_ruleset_name" {
  description = "Name of the hotfix branch ruleset"
  type        = string
  default     = "Hotfix Branch Protection"
}

variable "hotfix_branch_enforcement" {
  description = "Enforcement level for hotfix branch ruleset"
  type        = string
  default     = "active"
  validation {
    condition     = contains(["disabled", "active", "evaluate"], var.hotfix_branch_enforcement)
    error_message = "Enforcement must be one of: disabled, active, evaluate."
  }
}

variable "hotfix_branch_patterns" {
  description = "List of patterns that match hotfix branches"
  type        = list(string)
  default     = ["hotfix/*", "fix/*"]
}

variable "hotfix_branch_allow_deletion" {
  description = "Allow deletion of hotfix branches"
  type        = bool
  default     = true
}

variable "hotfix_branch_prevent_force_push" {
  description = "Prevent force pushes to hotfix branches"
  type        = bool
  default     = true
}

variable "hotfix_branch_allow_updates" {
  description = "Allow updates to hotfix branches"
  type        = bool
  default     = true
}

variable "hotfix_branch_require_linear_history" {
  description = "Require linear history on hotfix branches"
  type        = bool
  default     = true
}

variable "hotfix_branch_required_reviews" {
  description = "Number of required approving reviews for hotfix branches"
  type        = number
  default     = 2
  validation {
    condition     = var.hotfix_branch_required_reviews >= 1 && var.hotfix_branch_required_reviews <= 6
    error_message = "Required reviews must be between 1 and 6."
  }
}

variable "hotfix_branch_dismiss_stale_reviews" {
  description = "Dismiss stale reviews when new commits are pushed to hotfix branches"
  type        = bool
  default     = true
}

variable "hotfix_branch_require_code_owner_reviews" {
  description = "Require code owner reviews for hotfix branches"
  type        = bool
  default     = true
}

variable "hotfix_branch_require_last_push_approval" {
  description = "Require approval from someone other than the last pusher"
  type        = bool
  default     = true
}

variable "hotfix_branch_require_conversation_resolution" {
  description = "Require conversation resolution before merging hotfix branches"
  type        = bool
  default     = true
}

variable "hotfix_branch_status_checks" {
  description = "List of required status checks for hotfix branches"
  type = list(object({
    context        = string
    integration_id = optional(number)
  }))
  default = []
}

variable "hotfix_branch_strict_status_checks" {
  description = "Require hotfix branches to be up to date before merging"
  type        = bool
  default     = true
}

variable "hotfix_branch_name_pattern" {
  description = "Regex pattern for hotfix branch names"
  type        = string
  default     = "^(hotfix|fix)/.+"
}

variable "hotfix_branch_commit_message_pattern" {
  description = "Regex pattern for commit messages on hotfix branches"
  type        = string
  default     = null
}

variable "hotfix_branch_require_signed_commits" {
  description = "Require signed commits on hotfix branches"
  type        = bool
  default     = false
}

variable "hotfix_branch_bypass_actors" {
  description = "List of actors who can bypass hotfix branch protection"
  type = list(object({
    actor_id    = number
    actor_type  = string
    bypass_mode = string
  }))
  default = []
}

# =============================================================================
# PUSH RESTRICTIONS
# =============================================================================

variable "enable_push_restrictions" {
  description = "Enable repository-wide push restrictions"
  type        = bool
  default     = false
}

variable "push_restrictions_ruleset_name" {
  description = "Name of the push restrictions ruleset"
  type        = string
  default     = "Repository Push Restrictions"
}

variable "push_restrictions_enforcement" {
  description = "Enforcement level for push restrictions ruleset"
  type        = string
  default     = "active"
  validation {
    condition     = contains(["disabled", "active", "evaluate"], var.push_restrictions_enforcement)
    error_message = "Enforcement must be one of: disabled, active, evaluate."
  }
}



variable "push_restrictions_bypass_actors" {
  description = "List of actors who can bypass push restrictions"
  type = list(object({
    actor_id    = number
    actor_type  = string
    bypass_mode = string
  }))
  default = []
}

# =============================================================================
# TAG PROTECTION
# =============================================================================

variable "enable_tag_protection" {
  description = "Enable tag protection rules"
  type        = bool
  default     = true
}

variable "tag_protection_ruleset_name" {
  description = "Name of the tag protection ruleset"
  type        = string
  default     = "Tag Protection"
}

variable "tag_protection_enforcement" {
  description = "Enforcement level for tag protection ruleset"
  type        = string
  default     = "active"
  validation {
    condition     = contains(["disabled", "active", "evaluate"], var.tag_protection_enforcement)
    error_message = "Enforcement must be one of: disabled, active, evaluate."
  }
}

variable "tag_protection_patterns" {
  description = "List of patterns that match protected tags"
  type        = list(string)
  default     = ["v*", "release-*"]
}

variable "tag_allow_creation" {
  description = "Allow tag creation"
  type        = bool
  default     = true
}

variable "tag_allow_deletion" {
  description = "Allow tag deletion"
  type        = bool
  default     = false
}

variable "tag_allow_updates" {
  description = "Allow tag updates"
  type        = bool
  default     = false
}

variable "tag_name_pattern" {
  description = "Regex pattern for tag names"
  type        = string
  default     = "^v[0-9]+\\.[0-9]+\\.[0-9]+.*"
}

variable "tag_require_signed_commits" {
  description = "Require signed commits for tags"
  type        = bool
  default     = false
}

variable "tag_protection_bypass_actors" {
  description = "List of actors who can bypass tag protection"
  type = list(object({
    actor_id    = number
    actor_type  = string
    bypass_mode = string
  }))
  default = []
}

# =============================================================================
# DEPLOYMENT ENVIRONMENTS
# =============================================================================

variable "create_development_environment" {
  description = "Create development environment"
  type        = bool
  default     = true
}

variable "development_environment_name" {
  description = "Name of the development environment"
  type        = string
  default     = "development"
}

variable "development_environment_reviewers" {
  description = "List of reviewers for development environment"
  type = list(object({
    teams = optional(list(string), [])
    users = optional(list(string), [])
  }))
  default = []
}

variable "development_environment_wait_timer" {
  description = "Wait timer in minutes for development environment"
  type        = number
  default     = 0
}

variable "development_environment_prevent_self_review" {
  description = "Prevent self-review in development environment"
  type        = bool
  default     = false
}

variable "create_staging_environment" {
  description = "Create staging environment"
  type        = bool
  default     = true
}

variable "staging_environment_name" {
  description = "Name of the staging environment"
  type        = string
  default     = "staging"
}

variable "staging_environment_reviewers" {
  description = "List of reviewers for staging environment"
  type = list(object({
    teams = optional(list(string), [])
    users = optional(list(string), [])
  }))
  default = []
}

variable "staging_environment_wait_timer" {
  description = "Wait timer in minutes for staging environment"
  type        = number
  default     = 0
}

variable "staging_environment_prevent_self_review" {
  description = "Prevent self-review in staging environment"
  type        = bool
  default     = true
}

variable "create_production_environment" {
  description = "Create production environment"
  type        = bool
  default     = true
}

variable "production_environment_name" {
  description = "Name of the production environment"
  type        = string
  default     = "production"
}

variable "production_environment_reviewers" {
  description = "List of reviewers for production environment"
  type = list(object({
    teams = optional(list(string), [])
    users = optional(list(string), [])
  }))
  default = []
}

variable "production_environment_wait_timer" {
  description = "Wait timer in minutes for production environment"
  type        = number
  default     = 0
}

variable "production_environment_prevent_self_review" {
  description = "Prevent self-review in production environment"
  type        = bool
  default     = true
}

# =============================================================================
# WEBHOOKS AND AUTOMATION
# =============================================================================

variable "enable_gitflow_webhooks" {
  description = "Enable webhooks for GitFlow automation"
  type        = bool
  default     = false
}

variable "webhook_url" {
  description = "URL for GitFlow automation webhook"
  type        = string
  default     = ""
}

variable "webhook_content_type" {
  description = "Content type for webhook"
  type        = string
  default     = "json"
  validation {
    condition     = contains(["json", "form"], var.webhook_content_type)
    error_message = "Content type must be either 'json' or 'form'."
  }
}

variable "webhook_insecure_ssl" {
  description = "Allow insecure SSL for webhook"
  type        = bool
  default     = false
}

variable "webhook_secret" {
  description = "Secret for webhook authentication"
  type        = string
  default     = ""
  sensitive   = true
}

variable "webhook_active" {
  description = "Whether the webhook is active"
  type        = bool
  default     = true
}

variable "webhook_events" {
  description = "List of events that trigger the webhook"
  type        = list(string)
  default = [
    "push",
    "pull_request",
    "pull_request_review",
    "create",
    "delete",
    "release"
  ]
}

# =============================================================================
# REPOSITORY TOPICS
# =============================================================================

variable "add_repository_topics" {
  description = "Add topics to the repository for discoverability"
  type        = bool
  default     = false
}

variable "repository_topics" {
  description = "List of topics to add to the repository"
  type        = list(string)
  default     = []
}

###############################################################################
# PROVIDER CONFIGURATION
###############################################################################

variable "github_owner" {
  type        = string
  description = "GitHub user or organisation that owns the repository."

  validation {
    condition     = can(regex("^[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?$", var.github_owner))
    error_message = "GitHub owner must contain only alphanumeric characters and hyphens, and cannot start or end with a hyphen."
  }

  validation {
    condition     = length(var.github_owner) <= 39
    error_message = "GitHub owner must be 39 characters or less."
  }
}

variable "github_token" {
  type        = string
  description = "PAT with repo/admin:org scope. Leave unset → use GITHUB_TOKEN env."
  sensitive   = true
  default     = null
}

variable "github_base_url" {
  type        = string
  description = "GitHub base URL for GitHub Enterprise Server. Leave null for github.com."
  default     = null
}

variable "github_write_delay_ms" {
  type        = number
  description = "Time in milliseconds to sleep between writes to avoid rate limiting."
  default     = 1000
}

variable "github_read_delay_ms" {
  type        = number
  description = "Time in milliseconds to sleep between reads to avoid rate limiting."
  default     = 0
}

variable "github_retry_delay_ms" {
  type        = number
  description = "Time in milliseconds to sleep before retrying a request."
  default     = 1000
}

variable "github_retry_max_delay_ms" {
  type        = number
  description = "Maximum time in milliseconds to sleep before retrying a request."
  default     = 30000
}

variable "github_max_retries" {
  type        = number
  description = "Maximum number of retries for a request."
  default     = 3
}

###############################################################################
# CORE REPOSITORY CONFIGURATION
###############################################################################

variable "repository_name" {
  type        = string
  description = "Name of the repository to manage."

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+$", var.repository_name))
    error_message = "Repository name must contain only alphanumeric characters, periods, underscores, and hyphens."
  }

  validation {
    condition     = length(var.repository_name) <= 100
    error_message = "Repository name must be 100 characters or less."
  }

  validation {
    condition     = length(var.repository_name) >= 1
    error_message = "Repository name cannot be empty."
  }
}

variable "repository_visibility" {
  type        = string
  description = "Repository visibility: public, private, or internal."
  default     = "private"
  validation {
    condition     = contains(["public", "private", "internal"], var.repository_visibility)
    error_message = "Repository visibility must be public, private, or internal."
  }
}

variable "repo_allow_merge_commit" {
  type        = bool
  description = "Allow merge commits for pull requests."
  default     = true
}

variable "repo_allow_rebase_merge" {
  type        = bool
  description = "Allow rebase merging for pull requests."
  default     = true
}

variable "repo_allow_squash_merge" {
  type        = bool
  description = "Allow squash merging for pull requests."
  default     = true
}

variable "repo_has_wiki" {
  type        = bool
  description = "Enable repository wiki."
  default     = false
}

variable "repo_has_projects" {
  type        = bool
  description = "Enable repository projects."
  default     = false
}

###############################################################################
# SECURITY FEATURES
###############################################################################

variable "enable_advanced_security" {
  type        = bool
  description = "Enable GitHub Advanced Security features."
  default     = true
}

variable "enable_secret_scanning" {
  type        = bool
  description = "Enable secret scanning."
  default     = true
}

variable "enable_secret_scanning_push_protection" {
  type        = bool
  description = "Enable secret scanning push protection."
  default     = true
}

variable "enable_dependabot_security_updates" {
  type        = bool
  description = "Enable Dependabot security updates."
  default     = true
}

###############################################################################
# GITFLOW BRANCH CONFIGURATION
###############################################################################

variable "enable_gitflow" {
  type        = bool
  description = "Enable full GitFlow workflow (develop/release/hotfix branches). Set to false for trunk-based development."
  default     = true
}

variable "main_branch_name" {
  type        = string
  description = "Name of the main/production branch."
  default     = "main"

  validation {
    condition     = can(regex("^[a-zA-Z0-9/_.-]+$", var.main_branch_name))
    error_message = "Branch name must contain only alphanumeric characters, slashes, underscores, periods, and hyphens."
  }

  validation {
    condition     = length(var.main_branch_name) <= 250
    error_message = "Branch name must be 250 characters or less."
  }
}

variable "develop_branch_name" {
  type        = string
  description = "Name of the develop/integration branch."
  default     = "develop"

  validation {
    condition     = can(regex("^[a-zA-Z0-9/_.-]+$", var.develop_branch_name))
    error_message = "Branch name must contain only alphanumeric characters, slashes, underscores, periods, and hyphens."
  }

  validation {
    condition     = length(var.develop_branch_name) <= 250
    error_message = "Branch name must be 250 characters or less."
  }
}

variable "enable_develop_branch" {
  type        = bool
  description = "Create and manage the develop branch (automatically enabled when enable_gitflow is true)."
  default     = true
}

variable "set_develop_as_default" {
  type        = bool
  description = "Set develop branch as the default branch (not recommended for GitFlow)."
  default     = false
}

variable "enable_feature_branches" {
  type        = bool
  description = "Enable feature branch protection rules."
  default     = true
}

variable "enable_release_branches" {
  type        = bool
  description = "Enable release branch protection rules."
  default     = true
}

variable "enable_hotfix_branches" {
  type        = bool
  description = "Enable hotfix branch protection rules."
  default     = true
}

###############################################################################
# BRANCH PROTECTION RULES
###############################################################################

variable "main_branch_require_signed_commits" {
  type        = bool
  description = "Require signed commits on main branch."
  default     = true
}

variable "develop_branch_require_signed_commits" {
  type        = bool
  description = "Require signed commits on develop branch."
  default     = false
}

variable "release_branch_require_signed_commits" {
  type        = bool
  description = "Require signed commits on release branches."
  default     = true
}

variable "hotfix_branch_require_signed_commits" {
  type        = bool
  description = "Require signed commits on hotfix branches."
  default     = true
}

variable "main_branch_status_checks" {
  type        = list(string)
  description = "Required status checks for main branch."
  default     = []
}

variable "develop_branch_status_checks" {
  type        = list(string)
  description = "Required status checks for develop branch."
  default     = []
}

variable "release_branch_status_checks" {
  type        = list(string)
  description = "Required status checks for release branches."
  default     = []
}

variable "hotfix_branch_status_checks" {
  type        = list(string)
  description = "Required status checks for hotfix branches."
  default     = []
}

variable "dismiss_stale_reviews" {
  type        = bool
  description = "Dismiss stale reviews when new commits are pushed."
  default     = true
}

variable "require_code_owner_reviews" {
  type        = bool
  description = "Require code owner reviews."
  default     = false
}

variable "require_last_push_approval" {
  type        = bool
  description = "Require approval from someone other than the last pusher."
  default     = false
}

variable "conventional_commit_regex" {
  type        = string
  description = "Regex pattern for conventional commit messages."
  default     = "^(feat|fix|docs|style|refactor|perf|test|chore)(\\(.+\\))?: .+$"
}

variable "commit_author_email_pattern" {
  type        = string
  description = "Regex pattern for commit author email addresses (e.g., '@your-org.com$')."
  default     = ""
}

variable "required_workflows" {
  type = list(object({
    path       = string
    repository = string
    ref        = optional(string, "main")
  }))
  description = "List of required GitHub Actions workflows that must pass."
  default     = []
}

variable "enable_tag_protection" {
  type        = bool
  description = "Enable tag protection for release tags."
  default     = true
}

variable "enable_push_rules" {
  type        = bool
  description = "Enable push rules to restrict file types and sizes."
  default     = true
}

variable "max_file_size_mb" {
  type        = number
  description = "Maximum file size in MB for push rules."
  default     = 5
}

variable "blocked_file_extensions" {
  type        = list(string)
  description = "File extensions to block in push rules."
  default     = ["exe", "zip", "tar.gz", "dmg", "pkg", "deb", "rpm"]
}

variable "restricted_file_paths" {
  type        = list(string)
  description = "File paths to restrict in push rules (using fnmatch patterns)."
  default     = []
}

variable "restricted_file_extensions" {
  type        = list(string)
  description = "File extensions to restrict in push rules."
  default     = []
}

variable "max_file_path_length" {
  type        = number
  description = "Maximum file path length for push rules (0 = disabled)."
  default     = 0
}

variable "default_branch" {
  type        = string
  description = "Default branch name for the repository."
  default     = "main"
}

variable "enable_codeowners_file" {
  type        = bool
  description = "Create and manage a CODEOWNERS file."
  default     = true
}

variable "codeowners_content" {
  type        = string
  description = "Content for the CODEOWNERS file."
  default     = "# Global code owners\n* @admins\n"
}

variable "manage_topics_in_terraform" {
  type        = bool
  description = "Whether to manage repository topics in Terraform (true) or allow manual UI edits (false)."
  default     = false
}

variable "repository_topics" {
  type        = list(string)
  description = "Optional list of repository topics to manage when manage_topics_in_terraform is true."
  default     = []
}

###############################################################################
# BRANCH OVERRIDES
###############################################################################

variable "main_branch_overrides" {
  type        = map(any)
  description = "Override settings for main branch ruleset."
  default     = {}
}

variable "develop_branch_overrides" {
  type        = map(any)
  description = "Override settings for develop branch ruleset."
  default     = {}
}

###############################################################################
# BYPASS ACTORS
###############################################################################

variable "bypass_actors" {
  description = "List of actors (users/teams/apps) allowed to bypass restrictions."
  type = list(object({
    actor_id    = number
    actor_type  = string # RepositoryRole, Team, Integration, OrganizationAdmin
    bypass_mode = string # always, pull_request, push
  }))
  default = []

  validation {
    condition = alltrue([
      for actor in var.bypass_actors : contains(["RepositoryRole", "Team", "Integration", "OrganizationAdmin"], actor.actor_type)
    ])
    error_message = "Actor type must be one of: RepositoryRole, Team, Integration, OrganizationAdmin."
  }

  validation {
    condition = alltrue([
      for actor in var.bypass_actors : contains(["always", "pull_request", "push"], actor.bypass_mode)
    ])
    error_message = "Bypass mode must be one of: always, pull_request, push."
  }

  validation {
    condition = alltrue([
      for actor in var.bypass_actors : actor.actor_id > 0
    ])
    error_message = "Actor ID must be a positive number (GitHub user/team/app ID)."
  }
}

###############################################################################
# ENVIRONMENTS
###############################################################################

variable "enable_dev_environment" {
  type        = bool
  description = "Enable development environment."
  default     = true
}

variable "enable_stage_environment" {
  type        = bool
  description = "Enable staging environment."
  default     = true
}

variable "enable_prod_environment" {
  type        = bool
  description = "Enable production environment."
  default     = true
}

variable "dev_env_reviewers" {
  type        = list(string)
  description = "List of GitHub usernames who can review development deployments. (Currently not implemented - GitHub API requires numeric user IDs)"
  default     = []

  validation {
    condition = alltrue([
      for reviewer in var.dev_env_reviewers : can(regex("^[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?$", reviewer))
    ])
    error_message = "GitHub usernames must contain only alphanumeric characters and hyphens, and cannot start or end with a hyphen."
  }

  validation {
    condition     = length(var.dev_env_reviewers) <= 6
    error_message = "Maximum of 6 reviewers allowed per environment."
  }
}

variable "stage_env_reviewers" {
  type        = list(string)
  description = "List of GitHub usernames who can review staging deployments. (Currently not implemented - GitHub API requires numeric user IDs)"
  default     = []

  validation {
    condition = alltrue([
      for reviewer in var.stage_env_reviewers : can(regex("^[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?$", reviewer))
    ])
    error_message = "GitHub usernames must contain only alphanumeric characters and hyphens, and cannot start or end with a hyphen."
  }

  validation {
    condition     = length(var.stage_env_reviewers) <= 6
    error_message = "Maximum of 6 reviewers allowed per environment."
  }
}

variable "prod_env_reviewers" {
  type        = list(string)
  description = "List of GitHub usernames who can review production deployments. (Currently not implemented - GitHub API requires numeric user IDs)"
  default     = []

  validation {
    condition = alltrue([
      for reviewer in var.prod_env_reviewers : can(regex("^[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?$", reviewer))
    ])
    error_message = "GitHub usernames must contain only alphanumeric characters and hyphens, and cannot start or end with a hyphen."
  }

  validation {
    condition     = length(var.prod_env_reviewers) <= 6
    error_message = "Maximum of 6 reviewers allowed per environment."
  }
}

###############################################################################
# WEBHOOKS
###############################################################################

variable "enable_webhook" {
  type        = bool
  description = "Enable GitFlow automation webhook."
  default     = false
}

variable "webhook_url" {
  type        = string
  description = "Webhook URL for GitFlow automation."
  default     = ""

  validation {
    condition     = var.webhook_url == "" || can(regex("^https?://", var.webhook_url))
    error_message = "Webhook URL must be empty or start with http:// or https://."
  }
}

variable "webhook_secret" {
  type        = string
  description = "Webhook secret for GitFlow automation."
  sensitive   = true
  default     = ""
}

variable "webhook_insecure_ssl" {
  type        = bool
  description = "Allow insecure SSL for webhook."
  default     = false
}

variable "webhook_events" {
  type        = list(string)
  description = "List of events to trigger webhook."
  default     = ["push", "pull_request", "release"]
}

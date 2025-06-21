###############################################################################
# PROVIDER CONFIGURATION
###############################################################################

variable "github_owner" {
  type        = string
  description = "GitHub user or organisation that owns the repository."
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

###############################################################################
# CORE REPOSITORY CONFIGURATION
###############################################################################

variable "repository_name" {
  type        = string
  description = "Name of the repository to manage."
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

variable "main_branch_name" {
  type        = string
  description = "Name of the main/production branch."
  default     = "main"
}

variable "develop_branch_name" {
  type        = string
  description = "Name of the develop/integration branch."
  default     = "develop"
}

variable "enable_develop_branch" {
  type        = bool
  description = "Create and manage the develop branch."
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
    id   = string
    type = string # USER, TEAM, INTEGRATION
    mode = string # always, pull_request, push
  }))
  default = []
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
  description = "List of teams/users who can review development deployments."
  default     = []
}

variable "stage_env_reviewers" {
  type        = list(string)
  description = "List of teams/users who can review staging deployments."
  default     = []
}

variable "prod_env_reviewers" {
  type        = list(string)
  description = "List of teams/users who can review production deployments."
  default     = []
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

variable "repository_full_name" {
  description = "Full name of the repository (owner/repo-name)"
  type        = string
  default     = "drengskapur/takserver"
}

variable "main_branch_required_reviews" {
  description = "Number of required approving reviews for main branch"
  type        = number
  default     = 1
}

variable "develop_branch_required_reviews" {
  description = "Number of required approving reviews for develop branch"
  type        = number
  default     = 1
}

variable "main_branch_status_checks" {
  description = "List of status check contexts required for main branch"
  type        = list(string)
  default     = []
  # Example: ["ci/build", "ci/test", "ci/security-scan"]
}

variable "develop_branch_status_checks" {
  description = "List of status check contexts required for develop branch"
  type        = list(string)
  default     = []
  # Example: ["ci/build", "ci/test"]
}

variable "require_code_owner_reviews" {
  description = "Require code owner reviews for main branch"
  type        = bool
  default     = false
}

variable "require_signed_commits" {
  description = "Require signed commits for main branch"
  type        = bool
  default     = false
}

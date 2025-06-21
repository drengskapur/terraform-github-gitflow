terraform {
  required_version = ">= 1.9.0"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.6.0"
    }
  }
}

# Configure the GitHub provider
# You can use any of these methods:
# 1. Set GITHUB_TOKEN environment variable
# 2. Use GitHub CLI authentication (gh auth login)
# 3. Provide token directly (not recommended for production)

provider "github" {
  owner = "your-github-username-or-org"  # Replace with your GitHub username/org
  # token = var.github_token  # Optional: leave unset to use GITHUB_TOKEN env var
}

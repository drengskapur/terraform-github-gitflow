# Terraform GitHub GitFlow Module

A comprehensive Terraform module for implementing GitFlow branching strategy with modern GitHub repository management features including branch protection, environments, security scanning, and compliance controls.

## Features

- ✅ **Complete GitFlow workflow** (main/develop/feature/release/hotfix branches)
- ✅ **Modern branch protection** with repository rulesets
- ✅ **GitHub Environments** for deployment workflows
- ✅ **Security features** (Advanced Security, secret scanning, Dependabot)
- ✅ **Compliance controls** (CODEOWNERS, signed commits, conventional commits)
- ✅ **Webhook integration** for external automation
- ✅ **Production-ready defaults** with extensive customization options

## Quick Start

```hcl
module "gitflow_repository" {
  source = "drengskapur/terraform-github-gitflow/github"

  github_owner    = "your-org"
  repository_name = "your-repo"

  # Enable full GitFlow workflow
  enable_gitflow = true

  # Security features
  enable_advanced_security = true
  enable_secret_scanning   = true
}
```

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

## Branch Protection Rules

### Main Branch

- Requires pull request reviews (configurable count)
- Dismisses stale reviews on new commits
- Requires approval from someone other than author
- Blocks direct pushes and force pushes
- Cannot be deleted
- Optionally requires code owner reviews
- Optionally requires signed commits

### Develop Branch

- Requires pull request reviews (configurable count)
- Dismisses stale reviews on new commits
- Allows merge commits (non-linear history)
- Blocks direct pushes and force pushes
- More permissive than main branch

## Examples

### Basic GitFlow Setup

```hcl
module "gitflow_repository" {
  source = "drengskapur/terraform-github-gitflow/github"

  github_owner    = "your-org"
  repository_name = "basic-repo"

  # Enable GitFlow workflow
  enable_gitflow = true
}
```

### Complete Enterprise Setup

```hcl
module "gitflow_repository" {
  source = "drengskapur/terraform-github-gitflow/github"

  github_owner    = "your-org"
  repository_name = "enterprise-repo"

  # Full GitFlow with all environments
  enable_gitflow           = true
  enable_dev_environment   = true
  enable_stage_environment = true
  enable_prod_environment  = true

  # Security features
  enable_advanced_security               = true
  enable_secret_scanning                 = true
  enable_secret_scanning_push_protection = true
  enable_dependabot_security_updates     = true

  # Compliance controls
  enable_codeowners_file      = true
  commit_author_email_pattern = "@company\\.com$"

  # Enhanced protection
  enable_tag_protection = true
  enable_push_rules     = true
}
```

### Trunk-Based Development

```hcl
module "trunk_repository" {
  source = "drengskapur/terraform-github-gitflow/github"

  github_owner    = "your-org"
  repository_name = "trunk-repo"

  # Disable GitFlow for trunk-based development
  enable_gitflow        = false
  enable_develop_branch = false

  # Only production environment
  enable_prod_environment = true
}
```

For more examples, see the [examples](./examples/) directory.

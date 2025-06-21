# Terraform GitHub GitFlow Module

A Terraform module for setting up GitFlow branching strategy with idiomatic branch protection rules on GitHub repositories.

## Features

- ✅ **GitFlow branching strategy** setup (main + develop branches)
- ✅ **Idiomatic branch protection** with modern best practices
- ✅ **Automatic develop branch creation**
- ✅ **Customizable review requirements**
- ✅ **Configurable CI/CD status checks**
- ✅ **Production-ready defaults**

## Usage

```hcl
module "gitflow" {
  source = "drengskapur/gitflow/github"

  repository_full_name             = "owner/repo-name"
  main_branch_required_reviews     = 2
  develop_branch_required_reviews  = 1
  main_branch_status_checks        = ["ci/build", "ci/test"]
  develop_branch_status_checks     = ["ci/build"]
  require_code_owner_reviews       = true
  require_signed_commits           = false
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| github | ~> 6.0 |

## Providers

| Name | Version |
|------|---------|
| github | ~> 6.0 |

## Resources

| Name | Type |
|------|------|
| github_branch.develop | resource |
| github_branch_protection.develop | resource |
| github_branch_protection.main | resource |
| github_repository.repo | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| repository_full_name | Full name of the repository (owner/repo-name) | `string` | n/a | yes |
| main_branch_required_reviews | Number of required approving reviews for main branch | `number` | `1` | no |
| develop_branch_required_reviews | Number of required approving reviews for develop branch | `number` | `1` | no |
| main_branch_status_checks | List of status check contexts required for main branch | `list(string)` | `[]` | no |
| develop_branch_status_checks | List of status check contexts required for develop branch | `list(string)` | `[]` | no |
| require_code_owner_reviews | Require code owner reviews for main branch | `bool` | `false` | no |
| require_signed_commits | Require signed commits for main branch | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| repository_name | Name of the repository |
| repository_full_name | Full name of the repository |
| main_branch_protection_id | ID of the main branch protection rule |
| develop_branch_protection_id | ID of the develop branch protection rule |
| develop_branch_created | Whether the develop branch was created |
| branch_protection_summary | Summary of branch protection settings |

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

### Basic Usage

```hcl
module "branch_protection" {
  source = "./modules/github-branch-protection"

  repository_full_name = "myorg/myrepo"
}
```

### With CI/CD Integration

```hcl
module "branch_protection" {
  source = "./modules/github-branch-protection"

  repository_full_name             = "myorg/myrepo"
  main_branch_required_reviews     = 2
  main_branch_status_checks        = [
    "ci/build",
    "ci/test",
    "ci/security-scan",
    "ci/lint"
  ]
  develop_branch_status_checks     = [
    "ci/build",
    "ci/test"
  ]
  require_code_owner_reviews       = true
}
```

### High Security Setup

```hcl
module "branch_protection" {
  source = "./modules/github-branch-protection"

  repository_full_name             = "myorg/sensitive-repo"
  main_branch_required_reviews     = 3
  require_code_owner_reviews       = true
  require_signed_commits           = true
  main_branch_status_checks        = [
    "ci/build",
    "ci/test",
    "ci/security-scan",
    "ci/dependency-check",
    "ci/sast",
    "ci/dast"
  ]
}
```

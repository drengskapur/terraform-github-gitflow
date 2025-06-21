# Terraform GitHub GitFlow Module

Provision and manage GitHub repositories that follow the GitFlow branching model — all through Terraform.

* Creates the repository with optional wiki/projects settings
* Enforces branch-protection rulesets for `main`, `develop`, `feature/*`, `release/*`, and `hotfix/*`
* Optional tag-protection, CODEOWNERS, environments, webhook, Dependabot & security features
* Designed to work on free GitHub accounts (no Enterprise-only APIs required)

---

<!-- BEGIN_TF_DOCS -->

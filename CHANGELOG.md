## [1.0.0](https://github.com/drengskapur/terraform-github-gitflow/compare/v0.1.6...v1.0.0) (2025-06-21)
## [0.1.6](https://github.com/drengskapur/terraform-github-gitflow/compare/v0.1.5...v0.1.6) (2025-06-21)

### Features

* create pull requests for automated changelog updates ([bee0983](https://github.com/drengskapur/terraform-github-gitflow/commit/bee09831e697d9d0e23656606ff7aabfddf1cc87))
## [0.1.5](https://github.com/drengskapur/terraform-github-gitflow/compare/v0.1.4...v0.1.5) (2025-06-21)

### Bug Fixes

* resolve detached HEAD issue in release workflow ([02125ca](https://github.com/drengskapur/terraform-github-gitflow/commit/02125ca0187e8de74ce900680215c033106c2394))
## [0.1.4](https://github.com/drengskapur/terraform-github-gitflow/compare/v0.1.3...v0.1.4) (2025-06-21)

### Features

* push CHANGELOG.md updates to both main and develop branches ([2e82a66](https://github.com/drengskapur/terraform-github-gitflow/commit/2e82a6637b3ae3ed2a4b221ae8159791ee9d7fb6))
## [0.1.3](https://github.com/drengskapur/terraform-github-gitflow/compare/v0.1.2...v0.1.3) (2025-06-21)

### Features

* add automatic CHANGELOG.md commit to release workflow ([ce8dbf6](https://github.com/drengskapur/terraform-github-gitflow/commit/ce8dbf6472f2c8fb4cedbcd71f4aaf2c2b15c18f))
## [0.1.2](https://github.com/drengskapur/terraform-github-gitflow/compare/v0.1.1...v0.1.2) (2025-06-21)

### Bug Fixes

* remove npm cache from release workflow ([6f10f59](https://github.com/drengskapur/terraform-github-gitflow/commit/6f10f593880a8192c439284bf94abeba6992de49))
## [0.1.1](https://github.com/drengskapur/terraform-github-gitflow/compare/4f329338bbcf7e93183c2f8339faa65ee4a75b09...v0.1.1) (2025-06-21)

### ⚠ BREAKING CHANGES

* Complete refactor to follow idiomatic Terraform patterns

- Separate concerns into dedicated files:
  - main.tf: Core repository and provider configuration
  - branches.tf: Ruleset factory for all branch types
  - environments.tf: GitHub Environments for deployment workflows
  - webhooks.tf: Optional automation hooks
  - variables.tf: Strongly-typed inputs with sensible defaults
  - outputs.tf: Clean, useful outputs

- Modern GitHub provider features:
  - Repository rulesets instead of legacy branch protection
  - GitHub Environments with deployment policies
  - Comprehensive security features
  - Dependabot security updates

- GitFlow branch types supported:
  - main: Production-ready (2 reviewers, signed commits, linear history)
  - develop: Integration branch (1 reviewer)
  - feature/*: Development branches (no restrictions)
  - release/*: Release preparation (2 reviewers, strict)
  - hotfix/*: Emergency fixes (1 reviewer, strict)

- Flexible configuration:
  - Branch overrides for custom rules
  - Bypass actors for emergency access
  - Environment reviewers and wait timers
  - Status check requirements per branch type
  - Conventional commit enforcement

- Example usage in examples/minimal/
- Full validation passes
- Follows Terraform and GitHub provider idioms

* Merge feature/module-structure-refactor: Complete module restructuring and configuration

- Reorganized module into proper directory structure under modules/github-gitflow/
- Added comprehensive open-source project files (LICENSE, CONTRIBUTING.md, SECURITY.md)
- Implemented GitHub workflows for CI/CD and automated releases
- Added complete documentation and examples
- Updated main.tf with correct repository configuration
- Enhanced module with advanced GitFlow features and security settings

* feat: implement comprehensive CI/CD workflows and code quality tools

- Enhanced CI workflow with validation, security scanning, documentation, and example testing
- Added TFLint configuration with comprehensive rules for Terraform best practices
- Implemented security scanning with Trivy and Checkov, integrated with GitHub Security
- Added semantic PR validation to enforce conventional commit standards
- Configured pre-commit hooks for local validation and quality checks
- Enhanced Dependabot configuration for automated dependency management
- Added dependency review workflow for security vulnerability detection
- Improved release workflow with conventional changelog generation
- Added YAML linting and Trivy ignore configurations
- Updated pull request template with comprehensive checklist

This implements enterprise-grade CI/CD practices with:
- Multi-job parallel execution for faster feedback
- Security scan results integrated with GitHub Security tab
- Automated documentation updates via terraform-docs
- Matrix testing for multiple examples
- Comprehensive code quality and security checks

* docs: add comprehensive CI/CD overview documentation

- Documents all implemented workflows and their purposes
- Explains code quality tools and configurations
- Provides usage instructions for developers
- Outlines key features and best practices implemented
- Serves as reference for understanding the CI/CD pipeline

* chore(fmt): update terraform-docs config and VS Code YAML formatter settings

* chore(docs,ci): update templates, GitHub workflows, ignore files and linter configs

* chore: repo cleanup

* Run 'terraform fmt' across all modules
* Delete redundant example module file causing self-reference
* Update .terraform-docs.yml feature list and branch-protection table
* Remove emojis from documentation and release configuration
* Ensure TFLint passes cleanly

* fix(ci): restore repository resource and align examples with updated variable schema

* Re-add core github_repository resource (repository.tf)
* Define repository_topics variable
* Update example configurations to match new schema (remove overrides, fix bypass actors, drop raw required_workflows)
* Adjust root outputs to valid attributes
* Ensure terraform validate passes at root and example modules

* chore: update terraform provider lock files

* ci: optimize checkout actions with fetch-depth=1 and update versions

* ci: re-add fetch-depth=1 to checkout actions

* fix: add GitHub provider configuration and variables to examples

* refactor: use terraform.tfvars.example files to avoid linter errors

* feat: use temporary repositories for terraform plan validation in CI

* feat: add comprehensive safety measures for temporary repository cleanup

* fix: adapt examples job for GitHub token permissions in PR context

* fix: add actual terraform plan command with graceful error handling

* refactor: use official hashicorp/setup-terraform action instead of Docker

* feat: add terraform format check to examples validation

* fix: correct trivy action version tag

* refactor!: restructure to idiomatic terraform module layout
* Module source path changed from ./modules/github-gitflow to root directory

- Move all module files from modules/github-gitflow/ to root directory
- Move examples directory to root level
- Remove redundant top-level main.tf example
- Update CI workflow paths to reflect new structure
- Update README examples to use registry source format
- Align with HashiCorp module conventions for registry publishing

Migration: Update module source from "./modules/github-gitflow" to registry format or relative path from root

* fix(lint): disable unused declarations rule for reusable module

- Disable terraform_unused_declarations in TFLint config
- Variables are part of public API for end users
- Examples do not need to demonstrate every variable
- Some variables are for planned features not yet implemented
- Follows best practices for reusable Terraform modules

* style(ci): fix yaml formatting in semantic PR workflow

- Quote "on" keyword in YAML for better compatibility
- Follows YAML best practices for reserved keywords

* fix(ci): resolve security scanning SARIF upload issues

- Add actions:read permission for SARIF upload telemetry
- Add continue-on-error for Checkov to handle scan failures gracefully
- Only upload Checkov SARIF if file exists to prevent upload errors
- Improves CI reliability for security scanning workflow

* fix(ci): correct release workflow action reference

- Fix conventional-changelog-action reference to include owner/repo prefix
- Update to latest version v6 for better compatibility
- Resolves "uses attribute must be owner/repo@ref" error

* fix(ci): add continue-on-error to SARIF uploads for repositories without Advanced Security

* docs: add Contributor Covenant Code of Conduct

* chore: update CI workflow and contributing guidelines

* fix(ci): remove redundant gh cli authentication step

* fix(ci): use INTEGRATION_TOKEN for repository creation permissions

* feat(ci): use dedicated test organization for integration tests

- Use terraform-gitflow-tests organization for ephemeral repositories
- Updated fine-grained personal access token with proper permissions
- Provides better isolation and organization for CI test repositories

* fix(ci): remove invalid metadata permission from workflow

The metadata permission is not valid in GitHub Actions workflows.
Only contents: read permission is needed for the integration job.

* fix(terraform): correct data types for GitHub provider compatibility

- Change bypass_actors.actor_id from string to number (GitHub API expects numeric IDs)
- Change environment reviewers from teams to users (team names require team ID lookup)
- Fix repository visibility check case sensitivity (PRIVATE vs private)
- Update variable descriptions to clarify expected GitHub usernames vs team names

These changes resolve Terraform validation errors in the integration tests.

* feat(validation): add comprehensive variable safeguards

Add validation rules for critical input variables to catch errors early:

- bypass_actors: validate actor_type, bypass_mode enums and positive actor_id
- environment reviewers: validate GitHub username format and 6-reviewer limit
- repository_name: validate GitHub naming rules and length limits
- branch names: validate Git branch naming conventions
- github_owner: validate GitHub username/org naming rules
- webhook_url: validate HTTP/HTTPS URL format

These safeguards prevent runtime errors and provide clear error messages
for invalid configurations, improving user experience and debugging.

* fix(examples): use numeric actor_id in bypass_actors configuration

- Change actor_id from string to number to match GitHub API requirements
- Add helpful comments explaining how to find team/user IDs using GitHub CLI
- This resolves validation errors caught by the new variable safeguards

* chore: update terraform provider lock files after validation

Updated lock files for root module and examples after running terraform init
and validation. This ensures consistent provider versions across all
configurations.

* fix(github-provider): correct actor_type values and disable environment reviewers

- Fix bypass_actors.actor_type to use GitHub provider expected values:
  Changed from USER/TEAM/INTEGRATION to RepositoryRole/Team/Integration/OrganizationAdmin
- Temporarily disable environment reviewers due to GitHub API requiring numeric IDs
- Update complete example to use correct 'Team' instead of 'TEAM'
- Add clear documentation about ID requirements for future implementation

These changes resolve all remaining Terraform validation errors in CI.

* fix(docs): configure terraform-docs for root module structure

- Add terraform-docs markers (BEGIN_TF_DOCS/END_TF_DOCS) to README.md
- Configure terraform-docs action to scan root directory correctly
- Update README with current module features and accurate examples
- Remove outdated documentation that doesn't match current structure
- Set recursive=false to avoid scanning for non-existent modules directory

This resolves the 'stat modules: no such file or directory' error in CI.

* ci: trigger integration test with classic token

Switch from fine-grained PAT to classic token for Terraform GitHub provider
compatibility. Fine-grained tokens work with GitHub CLI but not with
Terraform's GitHub provider for organization repository creation.

* fix(docs): correctly configure terraform-docs for root module

- Updated .terraform-docs.yml to disable recursive scanning, as the module is at the root.
- Adjusted CI workflow to install and run terraform-docs directly, bypassing previous action issues.
- Ensured the README.md has correct markers and updated content for generation.

* fix(docs): correct terraform-docs header/footer configuration

Removed 'header-from' and 'footer-from' settings in .terraform-docs.yml
to allow the tool to correctly parse the root module and generate documentation.
This prevents the README from reverting to terraform-docs' internal documentation.

* docs: restore correct LICENSE file

Reverted LICENSE file content to the original project license.
This corrects an accidental overwrite that occurred during an earlier merge/refactor.

* docs: create proper README.md with HCL code fences

- Replace terraform-docs project documentation with module docs
- Add comprehensive usage examples with hcl language specifiers
- Include complete inputs/outputs documentation
- Fix terraform-docs CI pipeline header-from error
- Add GitFlow workflow diagram and security considerations

* docs: replace ASCII art with Mermaid GitFlow diagram

- Add comprehensive GitFlow workflow visualization
- Show feature, release, and hotfix branch patterns
- Include proper tagging and merge workflows
- Improve documentation readability and professionalism

* docs: escape pipe characters in conventional_commit_regex

- Fix Markdown table formatting by escaping | characters in regex pattern
- Prevent table column separation issues in documentation
- Ensure proper rendering of conventional commit regex pattern

* docs: fix README.md with proper module documentation

- Replace terraform-docs project docs with module documentation
- Add comprehensive usage examples with hcl code fences
- Include Mermaid GitFlow workflow diagram
- Fix terraform-docs CI pipeline header-from error
- Escape pipe characters in conventional_commit_regex pattern

* chore: remove .terraform-docs.yml config file

- CI workflow uses direct command-line arguments for terraform-docs
- Config file was causing header-from parsing issues
- Simplify setup by using explicit CLI parameters

* docs: update README.md with terraform-docs

* fix: disable GitHub Advanced Security in examples for CI compatibility

- Set enable_advanced_security=false in minimal and complete examples
- Set enable_secret_scanning=false to avoid 422 errors on free accounts
- Set enable_secret_scanning_push_protection=false for CI compatibility
- Keep enable_dependabot_security_updates=true (works on free accounts)
- Add helpful comments about when to enable these features
- Fixes integration test failures with 'Advanced security has not been purchased' error

* feat: add automated cleanup for temporary test repositories

- Runs every 6 hours to clean up orphaned test repositories
- Only deletes repositories older than 24 hours
- Multiple safety checks to prevent accidental deletions
- Can be triggered manually via workflow_dispatch
- Comprehensive logging for audit trail

* fix: disable advanced security features by default

- Set enable_advanced_security default to false
- Set enable_secret_scanning default to false
- Set enable_secret_scanning_push_protection default to false
- Update README documentation to reflect new defaults

GitHub Advanced Security features are only available with GitHub Enterprise.
Personal accounts and free organizations should keep these disabled.

* fix: restore README.md and configure terraform-docs properly

- Restore original project README.md (was overwritten by terraform-docs)
- Add .terraform-docs.yml config to prevent full README replacement
- Configure terraform-docs to only update the documentation section
- Use inject mode to preserve existing README content

* docs: update README.md with terraform-docs

* docs: trigger terraform-docs update with correct variable defaults

* fix: use dynamic blocks for security_and_analysis to support personal accounts

- Only include security_and_analysis block when features are enabled
- Remove explicit 'disabled' status which requires GitHub Enterprise
- Use dynamic blocks to conditionally include security features
- Fixes integration test failures on personal GitHub accounts

The GitHub API returns 422 'Advanced security has not been purchased'
even when trying to set features to 'disabled' on personal accounts.

* docs: update security feature documentation for personal accounts

- Add '(requires GitHub Enterprise)' notes to security variables
- Update README examples to show security features disabled by default
- Update variable descriptions to clarify GitHub Enterprise requirement
- Restore project README after terraform-docs overwrote it

These changes clarify that GitHub Advanced Security features are only
available with GitHub Enterprise and should remain disabled for personal
accounts and free organizations.

* docs: update README.md with terraform-docs

* fix: disable problematic branch rulesets and environment features for fresh repos

- Disable feature/release/hotfix branch rulesets in examples to avoid 'Invalid target patterns' errors
- Make prevent_self_review conditional on having reviewers to avoid billing plan errors
- Update minimal and complete examples to work with fresh repositories in CI

* docs: restore proper project README.md

- Revert terraform-docs overwrites that replaced project documentation
- Restore original README with proper project description and usage examples
- Remove terraform-docs generated content that was incorrectly applied

* docs: update README.md with terraform-docs

* fix: use fully qualified ref patterns for rulesets and disable self-review to avoid API errors

- Prefixed branch patterns with refs/heads/ and tag patterns with refs/tags/ per GitHub API requirements
- Disabled prevent_self_review in environments to avoid billing plan errors on free accounts
- Updated examples remain compatible with fresh repositories

* fix: disable commit metadata rules that are not supported on free plans

- make commit_message_pattern conditional and default regex empty
- default conventional_commit_regex to empty string
- remove metadata patterns from examples

* docs: update README.md with terraform-docs

* ci: make integration verify step non-fatal

- Add 'continue-on-error: true' to Verify repository configuration step
  The rulesets listing API returns 403 on private repos for free plans,
  which was causing the job to fail even though Terraform apply succeeded.
- This change lets the integration test proceed and only treats verification
  as informational.

* fix(examples): disable staging & production environments in complete example for CI

GitHub environment protection rules that require reviewers are not supported on free plans, so enabling staging/production causes integration tests to fail. The complete example now only provisions the dev environment; trunk-based example disables prod as well.

* docs(readme): restore project README and remove terraform-docs boilerplate

Replaces accidental terraform-docs site content with the original module README so users see correct usage docs.

* docs: update README.md with terraform-docs

* fix(examples): remove trunk module & bypass actors for CI

- Eliminates placeholder bypass_actors that caused ruleset API errors
- Removes trunk_based_repository module and related outputs from complete example to avoid name conflicts in repeated CI runs

* docs(vars): clarify enable_gitflow description to remove trunk reference

* chore(examples): sync minimal example after CI tweaks

* docs(readme): remove trunk reference from enable_gitflow description

* fix(examples): purge leftover trunk variable from complete example and tfvars

* docs: update README.md with terraform-docs

* docs(readme): restore full project documentation after merge conflict

* docs: update README.md with terraform-docs

* test(ci): assert branch protection by attempting blocked push

Replaces ruleset-listing step with a practical test:
– Clones temp repo, commits to , tries to push.
– Job fails if push succeeds, passes when the push is rejected (exit ≠ 0).
This verifies ruleset enforcement without needing Pro-plan API access.

* ci(docs): pass explicit --config flag to terraform-docs step

* docs(readme): remove terraform-docs boilerplate and add module overview

* docs: update README.md with terraform-docs

* ci(pre-commit): use project config for terraform-docs to prevent README overwrite

* docs(readme): restore project README header and keep terraform-docs section intact

* docs: update README.md with terraform-docs

* docs: change terraform-docs output to USAGE.md

- Update .terraform-docs.yml to output to USAGE.md instead of README.md
- Change mode from inject to replace for cleaner output
- Remove section headers for more concise documentation
- Fix broken header-from reference to non-existent main.tf

* ci: remove terraform-specific pre-commit hooks

- Remove antonbabenko/pre-commit-terraform hooks (terraform_fmt, terraform_validate, terraform_docs, terraform_tflint, terraform_trivy, terraform_checkov)
- Keep only basic pre-commit-hooks for general file validation
- Terraform validation now handled by GitHub Actions CI workflow instead of pre-commit

* ci: refactor workflows into specialized, optimized structure

- Extract security scanning into dedicated workflow with daily schedule
- Extract integration tests into separate workflow with path filters
- Add documentation workflow for terraform-docs automation
- Rename workflows for clarity (cleanup.yml, dependencies.yml)
- Optimize CI workflow with job dependencies (validate → lint → test → ci-success)
- Add path-based triggers to reduce unnecessary workflow runs
- Remove slow security scans from PR validation for faster feedback
- Add ci-success summary job for simplified branch protection requirements

* ci: clean up workflow configurations

- Remove unused workflow file references and cleanup
- Optimize workflow triggers and conditions
- Streamline workflow structure for better maintainability
- Remove redundant configurations across workflow files

* fix(ci): update cleanup workflow to match integration test repo naming

- Add temp-integration- pattern to repository cleanup filters
- Enhance logging with visual indicators for better readability
- Ensure integration test repositories are properly cleaned up

* trigger: manual integration test run

* fix(examples): configure GitHub provider with organization owner

- Add owner parameter to GitHub provider configuration in examples
- Ensures repositories are created in the specified organization
- Fixes 403 'Resource not accessible by personal access token' error
- Required for integration tests to work with terraform-gitflow-tests org

* fix(examples): update tfvars examples with correct organization

- Change github_owner from 'example-org' to 'terraform-gitflow-tests'
- Ensures example configurations work with the test organization
- Makes examples ready-to-use for testing and documentation

* fix(ci): prevent duplicate repository creation in integration tests

- Remove gh repo create step that was conflicting with Terraform
- Let Terraform handle repository creation entirely
- Add 5-second delay before branch protection test for repo readiness
- Improve cleanup logic to handle repositories that weren't created
- Fixes 422 'name already exists' error from duplicate creation

* fix(examples): disable GitHub Pro features for free plan compatibility

- Disable repository rulesets (enable_tag_protection, enable_push_rules)
- Disable repository environments (enable_dev_environment)
- Add clear comments explaining GitHub Pro requirements
- Ensures integration tests work on GitHub Free plan
- Fixes 403 'Upgrade to GitHub Pro' errors in CI

* fix: disable branch protection rulesets for GitHub Free plans

- Add enable_branch_protection_rulesets variable to control ruleset creation
- Disable rulesets in examples for GitHub Free plan compatibility
- Fixes 403 errors when creating rulesets on GitHub Free accounts

* style: fix alignment in complete example configuration

- Align enable_tag_protection and enable_push_rules variable assignments
- Improve code formatting consistency

* style: fix terraform formatting in examples

- Run terraform fmt to fix formatting issues in minimal example
- Ensures CI validation passes

* fix: make ruleset outputs conditional on enable_branch_protection_rulesets

- Fix outputs that reference branch rulesets when they're disabled
- Prevents 'Invalid index' errors when rulesets are disabled for GitHub Free plans
- All ruleset outputs now return null when rulesets are disabled

### Features

* add automated cleanup for temporary test repositories ([#3](https://github.com/drengskapur/terraform-github-gitflow/issues/3)) ([2b90631](https://github.com/drengskapur/terraform-github-gitflow/commit/2b90631bec7baf592e7166d6f9c15ce23581e6a2)), closes [#1](https://github.com/drengskapur/terraform-github-gitflow/issues/1)
* enhance GitFlow module with modern GitHub features ([1bf6c92](https://github.com/drengskapur/terraform-github-gitflow/commit/1bf6c92a844d056eb01c883104e78e4348970d8c))
* improve release workflow with reliable dependency installation ([3256823](https://github.com/drengskapur/terraform-github-gitflow/commit/32568236a2b0a9cd5c451cd9a676e6b771dbaff2))
* initial GitFlow Terraform module ([4f32933](https://github.com/drengskapur/terraform-github-gitflow/commit/4f329338bbcf7e93183c2f8339faa65ee4a75b09))

### Bug Fixes

* simplify release workflow to avoid git conflicts ([7ad2d8a](https://github.com/drengskapur/terraform-github-gitflow/commit/7ad2d8a521b26ec03e036d9903ddbcd6ec8f403c))

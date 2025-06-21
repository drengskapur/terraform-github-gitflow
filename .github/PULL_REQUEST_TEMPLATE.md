<!--
PR Title should follow Conventional Commits, e.g.:
  feat(branches): add support for custom branch patterns
  fix(environments): correct deployment policy configuration
-->

## Description

Provide a clear and concise description of **what** this pull request does and **why**. Include any relevant context or background.

## Related Issue

Closes #<!-- issue number -->

## Type of Change

Select the option that best describes this pull request (remove those that do not apply):

- [ ] **feat**     – A new feature
- [ ] **fix**      – A bug fix
- [ ] **docs**     – Documentation only changes
- [ ] **refactor** – A code change that neither fixes a bug nor adds a feature
- [ ] **chore**    – Build process or auxiliary tool changes
- [ ] **ci**       – Continuous Integration related changes
- [ ] **breaking** – A change that breaks existing behaviour

## How Has This Been Tested?

Describe the tests you ran to verify your changes. Include instructions so reviewers can reproduce. If this PR adds or changes Terraform resources, please include the output of at least one successful `terraform plan`.

- [ ] `terraform validate` passes in `modules/github-gitflow`
- [ ] `terraform validate` passes in each example directory
- [ ] `terraform plan` succeeds for updated examples

## Screenshots (if applicable)

## Additional Context

Add any other information or links that may help the reviewer.

---

## Checklist

- [ ] My PR title follows the **Conventional Commits** specification
- [ ] I have rebased my branch on `develop` and resolved any conflicts
- [ ] I have run `pre-commit run -a` (or at least `terraform fmt -recursive`)
- [ ] I have run `terraform validate` and the configuration is valid
- [ ] I have run `tflint` and addressed all issues
- [ ] I have updated module or root **documentation** with `terraform-docs` where relevant
- [ ] I have added/updated **examples** if needed
- [ ] I have updated **CHANGELOG.md** following *Keep a Changelog*
- [ ] My changes generate **no new warnings** in workflows or tooling
- [ ] I have performed a self-review of my own code and added comments where necessary

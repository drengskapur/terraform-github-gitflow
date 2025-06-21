---
name: Bug Report
about: Report a reproducible issue with the terraform-github-gitflow module
title: "[BUG] <short description>"
labels:
  - bug
  - needs-triage
assignees: ""
---

## Bug Description

A clear and concise description of what the bug is.

## To Reproduce

Steps to reproduce the behavior:

1. Configure module with:

   ```hcl
   module "gitflow" {
     # Your configuration here
   }
   ```

2. Run `terraform plan/apply`
3. See error

## Expected Behavior

A clear and concise description of what you expected to happen.

## Actual Behavior

A clear and concise description of what actually happened.

## Environment

- **Terraform version**: [e.g. 1.9.0]
- **GitHub provider version**: [e.g. 6.6.0]
- **Operating System**: [e.g. macOS 14.0]
- **Module version**: [e.g. 1.0.0]

## Configuration

<details>
<summary>Terraform Configuration</summary>

```hcl
# Paste your Terraform configuration here
# Remove any sensitive information
```

</details>

## Terraform Output

<details>
<summary>Error Output</summary>

```plaintext
# Paste the error output here
```

</details>

## Additional Context

Add any other context about the problem here.

## Checklist

- [ ] I have searched the [existing issues](../../issues) for duplicates
- [ ] I have reproduced this issue with the **latest** module version
- [ ] I have provided a **minimal** Terraform configuration that reproduces the problem
- [ ] I have included **logs/output** where appropriate
- [ ] I have included the Terraform version, provider version and operating system

## Possible Solution

If you have ideas on how to fix this, please describe them here.

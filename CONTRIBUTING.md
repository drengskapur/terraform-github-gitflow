# Contributing to terraform-github-gitflow

We love your input! We want to make contributing to this project as easy and transparent as possible, whether it's:

- Reporting a bug
- Discussing the current state of the code
- Submitting a fix
- Proposing new features
- Becoming a maintainer

## We Develop with GitHub

We use GitHub to host code, to track issues and feature requests, as well as accept pull requests.

## We Use [GitFlow](https://nvie.com/posts/a-successful-git-branching-model/), So All Code Changes Happen Through Pull Requests

Pull requests are the best way to propose changes to the codebase. We actively welcome your pull requests:

1. Fork the repo and create your branch from `develop`.
2. If you've added code that should be tested, add tests.
3. If you've changed APIs, update the documentation.
4. Ensure the test suite passes.
5. Make sure your code lints.
6. Issue that pull request!

## Any contributions you make will be under the MIT Software License

In short, when you submit code changes, your submissions are understood to be under the same [MIT License](LICENSE) that covers the project. Feel free to contact the maintainers if that's a concern.

## Report bugs using GitHub's [issues](https://github.com/drengskapur/terraform-github-gitflow/issues)

We use GitHub issues to track public bugs. Report a bug by [opening a new issue](https://github.com/drengskapur/terraform-github-gitflow/issues/new); it's that easy!

## Write bug reports with detail, background, and sample code

**Great Bug Reports** tend to have:

- A quick summary and/or background
- Steps to reproduce
  - Be specific!
  - Give sample code if you can
- What you expected would happen
- What actually happens
- Notes (possibly including why you think this might be happening, or stuff you tried that didn't work)

People *love* thorough bug reports. I'm not even kidding.

## Development Process

### Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.9.0
- [GitHub Personal Access Token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) with appropriate permissions
- [pre-commit](https://pre-commit.com/) (recommended)
- [terraform-docs](https://terraform-docs.io/) (recommended)
- [tflint](https://github.com/terraform-linters/tflint) (recommended)

### Setting Up Your Development Environment

1. **Fork the repository**

   Click the "Fork" button in the upper right corner of the repository page.

2. **Clone your fork**

   ```bash
   git clone https://github.com/YOUR_USERNAME/terraform-github-gitflow.git
   cd terraform-github-gitflow
   ```

3. **Add upstream remote**

   ```bash
   git remote add upstream https://github.com/drengskapur/terraform-github-gitflow.git
   ```

4. **Create a feature branch**

   ```bash
   git checkout -b feature/your-feature-name
   ```

5. **Install pre-commit hooks** (recommended)

   ```bash
   pre-commit install
   ```

### Making Changes

1. **Follow the module structure**

   ```plaintext
   .
   ├── main.tf                    # Root-level example usage
   ├── versions.tf                # Root-level provider requirements
   ├── README.md                  # Project documentation
   ├── LICENSE                    # MIT License
   ├── CONTRIBUTING.md            # This file
   ├── SECURITY.md               # Security policy
   ├── CHANGELOG.md              # Version history
   ├── .github/                  # GitHub templates and workflows
   └── modules/
       └── github-gitflow/       # The actual module
           ├── main.tf           # Module's main configuration
           ├── variables.tf      # Module's input variables
           ├── outputs.tf        # Module's outputs
           ├── branches.tf       # GitFlow branch rulesets
           ├── environments.tf   # GitHub Environments
           ├── webhooks.tf       # Optional automation
           └── examples/         # Module usage examples
               ├── minimal/
               │   └── main.tf
               └── complete/
                   └── main.tf
   ```

2. **Write clear, documented code**
   - Add descriptions to all variables and outputs
   - Use meaningful resource names
   - Follow [Terraform style conventions](https://developer.hashicorp.com/terraform/language/style)

3. **Update documentation**
   - Run `terraform-docs markdown modules/github-gitflow > modules/github-gitflow/README.md` to update module documentation
   - Update examples in `modules/github-gitflow/examples/` if needed
   - Update root-level README.md if the module interface changes
   - Add entries to CHANGELOG.md following [Keep a Changelog](https://keepachangelog.com/)

### Testing Your Changes

1. **Format your code**

   ```bash
   terraform fmt -recursive
   ```

2. **Validate your code**

   ```bash
   # Validate the module
   cd modules/github-gitflow
   terraform validate
   cd ../..

   # Validate the root example
   terraform validate
   ```

3. **Run linting**

   ```bash
   tflint
   ```

4. **Test with examples**

   ```bash
   # Test minimal example
   cd modules/github-gitflow/examples/minimal
   terraform init
   terraform plan
   cd ../../../..

   # Test complete example
   cd modules/github-gitflow/examples/complete
   terraform init
   terraform plan
   cd ../../../..

   # Test root-level example
   terraform init
   terraform plan
   ```

5. **Test against a real repository** (optional but recommended)

   ```bash
   export GITHUB_TOKEN="your-token-here"
   terraform apply
   # Verify the configuration
   terraform destroy
   ```

### Commit Message Convention

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```plaintext
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**

- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation only changes
- `style`: Changes that do not affect the meaning of the code
- `refactor`: A code change that neither fixes a bug nor adds a feature
- `perf`: A code change that improves performance
- `test`: Adding missing tests or correcting existing tests
- `chore`: Changes to the build process or auxiliary tools

**Examples:**

```plaintext
feat(branches): add support for custom branch patterns
fix(environments): correct deployment policy configuration
docs(readme): update usage examples
docs(examples): add complete example with all features
chore(deps): update GitHub provider to v6.7.0
refactor(structure): reorganize into proper module structure
```

### Pull Request Process

1. **Update your branch**

   ```bash
   git fetch upstream
   git rebase upstream/develop
   ```

2. **Push your changes**

   ```bash
   git push origin feature/your-feature-name
   ```

3. **Create a Pull Request**
   - Go to your fork on GitHub
   - Click "New pull request"
   - Select `develop` as the base branch
   - Fill out the PR template
   - Link any related issues

4. **PR Checklist**
   - [ ] My code follows the project's style guidelines
   - [ ] I have performed a self-review of my own code
   - [ ] I have commented my code, particularly in hard-to-understand areas
   - [ ] I have made corresponding changes to the documentation
   - [ ] My changes generate no new warnings
   - [ ] I have added tests that prove my fix is effective or that my feature works
   - [ ] New and existing unit tests pass locally with my changes

## Code Style Guidelines

### Terraform Conventions

- Use 2 spaces for indentation
- Use snake_case for all resource names and variables
- Group resources by their purpose
- Order resource arguments: count/for_each, required, optional, blocks, lifecycle

### Variable and Output Conventions

```hcl
variable "example_variable" {
  description = "A clear description of what this variable does"
  type        = string
  default     = "default_value"

  validation {
    condition     = can(regex("^[a-z]+$", var.example_variable))
    error_message = "The example_variable must contain only lowercase letters."
  }
}

output "example_output" {
  description = "A clear description of what this output provides"
  value       = resource.example.attribute
  sensitive   = false
}
```

### Documentation Standards

- All variables and outputs must have descriptions
- Complex logic should be commented
- Examples should be working and tested
- README should include:
  - Module overview
  - Usage examples
  - Requirements
  - Providers
  - Resources created
  - Inputs and outputs (auto-generated)

## Community

### Code of Conduct

This project adheres to the [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior to the project maintainers.

### Getting Help

- Check the [documentation](README.md)
- Search [existing issues](https://github.com/drengskapur/terraform-github-gitflow/issues)
- Join our [discussions](https://github.com/drengskapur/terraform-github-gitflow/discussions)
- Ask in the Terraform community forums

### Recognition

Contributors will be recognized in:

- The project's CONTRIBUTORS.md file
- Release notes for significant contributions
- Special mention in documentation for major features

## Release Process

Maintainers will:

1. Create a release branch from `develop`
2. Update version in relevant files
3. Update CHANGELOG.md
4. Create PR to `main`
5. After merge, tag the release
6. Merge `main` back to `develop`
7. Publish release notes

## License

By contributing, you agree that your contributions will be licensed under the project's [MIT License](LICENSE).

---

Thank you for contributing to terraform-github-gitflow! 🚀

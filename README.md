# terraform-docs

[![Build Status](https://github.com/terraform-docs/terraform-docs/workflows/ci/badge.svg)](https://github.com/terraform-docs/terraform-docs/actions) [![GoDoc](https://pkg.go.dev/badge/github.com/terraform-docs/terraform-docs)](https://pkg.go.dev/github.com/terraform-docs/terraform-docs) [![Go Report Card](https://goreportcard.com/badge/github.com/terraform-docs/terraform-docs)](https://goreportcard.com/report/github.com/terraform-docs/terraform-docs) [![Codecov Report](https://codecov.io/gh/terraform-docs/terraform-docs/branch/master/graph/badge.svg)](https://codecov.io/gh/terraform-docs/terraform-docs) [![License](https://img.shields.io/github/license/terraform-docs/terraform-docs)](https://github.com/terraform-docs/terraform-docs/blob/master/LICENSE) [![Latest release](https://img.shields.io/github/v/release/terraform-docs/terraform-docs)](https://github.com/terraform-docs/terraform-docs/releases)

![terraform-docs-teaser](./images/terraform-docs-teaser.png)

## What is terraform-docs

A utility to generate documentation from Terraform modules in various output formats.

## Installation

macOS users can install using [Homebrew]:

```bash
brew install terraform-docs
```

or

```bash
brew install terraform-docs/tap/terraform-docs
```

Windows users can install using [Scoop]:

```bash
scoop bucket add terraform-docs https://github.com/terraform-docs/scoop-bucket
scoop install terraform-docs
```

or [Chocolatey]:

```bash
choco install terraform-docs
```

Stable binaries are also available on the [releases] page. To install, download the
binary for your platform from "Assets" and place this into your `$PATH`:

```bash
curl -Lo ./terraform-docs.tar.gz https://github.com/terraform-docs/terraform-docs/releases/download/v0.19.0/terraform-docs-v0.19.0-$(uname)-amd64.tar.gz
tar -xzf terraform-docs.tar.gz
chmod +x terraform-docs
mv terraform-docs /usr/local/bin/terraform-docs
```

**NOTE:** Windows releases are in `ZIP` format.

The latest version can be installed using `go install` or `go get`:

```bash
# go1.17+
go install github.com/terraform-docs/terraform-docs@v0.19.0
```

```bash
# go1.16
GO111MODULE="on" go get github.com/terraform-docs/terraform-docs@v0.19.0
```

**NOTE:** please use the latest Go to do this, minimum `go1.16` is required.

This will put `terraform-docs` in `$(go env GOPATH)/bin`. If you encounter the error
`terraform-docs: command not found` after installation then you may need to either add
that directory to your `$PATH` as shown [here] or do a manual installation by cloning
the repo and run `make build` from the repository which will put `terraform-docs` in:

```bash
$(go env GOPATH)/src/github.com/terraform-docs/terraform-docs/bin/$(uname | tr '[:upper:]' '[:lower:]')-amd64/terraform-docs
```

## Usage

### Running the binary directly

To run and generate documentation into README within a directory:

```bash
terraform-docs markdown table --output-file README.md --output-mode inject /path/to/module
```

Check [`output`] configuration for more details and examples.

### Using docker

terraform-docs can be run as a container by mounting a directory with `.tf`
files in it and run the following command:

```bash
docker run --rm --volume "$(pwd):/terraform-docs" -u $(id -u) quay.io/terraform-docs/terraform-docs:0.19.0 markdown /terraform-docs
```

If `output.file` is not enabled for this module, generated output can be redirected
back to a file:

```bash
docker run --rm --volume "$(pwd):/terraform-docs" -u $(id -u) quay.io/terraform-docs/terraform-docs:0.19.0 markdown /terraform-docs > doc.md
```

**NOTE:** Docker tag `latest` refers to _latest_ stable released version and `edge`
refers to HEAD of `master` at any given point in time.

### Using GitHub Actions

To use terraform-docs GitHub Action, configure a YAML workflow file (e.g.
`.github/workflows/documentation.yml`) with the following:

```yaml
name: Generate terraform docs
on:
  - pull_request

jobs:
  docs:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
      with:
        ref: ${{ github.event.pull_request.head.ref }}

    - name: Render terraform docs and push changes back to PR
      uses: terraform-docs/gh-actions@main
      with:
        working-dir: .
        output-file: README.md
        output-method: inject
        git-push: "true"
```

Read more about [terraform-docs GitHub Action] and its configuration and
examples.

### pre-commit hook

With pre-commit, you can ensure your Terraform module documentation is kept
up-to-date each time you make a commit.

First [install pre-commit] and then create or update a `.pre-commit-config.yaml`
in the root of your Git repo with at least the following content:

```yaml
repos:
  - repo: https://github.com/terraform-docs/terraform-docs
    rev: "v0.19.0"
    hooks:
      - id: terraform-docs-go
        args: ["markdown", "table", "--output-file", "README.md", "./mymodule/path"]
```

Then run:

```bash
pre-commit install
pre-commit install-hooks
```

Further changes to your module's `.tf` files will cause an update to documentation
when you make a commit.

## Configuration

terraform-docs can be configured with a yaml file. The default name of this file is
`.terraform-docs.yml` and the path order for locating it is:

1. root of module directory
1. `.config/` folder at root of module directory
1. current directory
1. `.config/` folder at current directory
1. `$HOME/.tfdocs.d/`

```yaml
formatter: "" # this is required

version: ""

header-from: main.tf
footer-from: ""

recursive:
  enabled: false
  path: modules
  include-main: true

sections:
  hide: []
  show: []

content: ""

output:
  file: ""
  mode: inject
  template: |-
    <!-- BEGIN_TF_DOCS -->
## Requirements

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_github"></a> [github](#requirement\_github) | ~> 6.0 |

## Providers

## Providers

| Name | Version |
|------|---------|
| <a name="provider_github"></a> [github](#provider\_github) | 6.6.0 |

## Modules

## Modules

No modules.

## Resources

## Resources

| Name | Type |
|------|------|
| [github_repository.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository) | resource |
| [github_repository_environment.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_environment) | resource |
| [github_repository_environment_deployment_policy.branch_policy](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_environment_deployment_policy) | resource |
| [github_repository_ruleset.branches](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_ruleset) | resource |
| [github_repository_ruleset.tags](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_ruleset) | resource |
| [github_repository_webhook.gitflow](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_webhook) | resource |

## Inputs

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_blocked_file_extensions"></a> [blocked\_file\_extensions](#input\_blocked\_file\_extensions) | File extensions to block in push rules. | `list(string)` | <pre>[<br/>  "exe",<br/>  "zip",<br/>  "tar.gz",<br/>  "dmg",<br/>  "pkg",<br/>  "deb",<br/>  "rpm"<br/>]</pre> | no |
| <a name="input_bypass_actors"></a> [bypass\_actors](#input\_bypass\_actors) | List of actors (users/teams/apps) allowed to bypass restrictions. | <pre>list(object({<br/>    actor_id    = number<br/>    actor_type  = string # RepositoryRole, Team, Integration, OrganizationAdmin<br/>    bypass_mode = string # always, pull_request, push<br/>  }))</pre> | `[]` | no |
| <a name="input_codeowners_content"></a> [codeowners\_content](#input\_codeowners\_content) | Content for the CODEOWNERS file. | `string` | `"# Global code owners\n* @admins\n"` | no |
| <a name="input_commit_author_email_pattern"></a> [commit\_author\_email\_pattern](#input\_commit\_author\_email\_pattern) | Regex pattern for commit author email addresses (e.g., '@your-org.com$'). | `string` | `""` | no |
| <a name="input_conventional_commit_regex"></a> [conventional\_commit\_regex](#input\_conventional\_commit\_regex) | Regex pattern for conventional commit messages. | `string` | `"^(feat|fix|docs|style|refactor|perf|test|chore)(\\(.+\\))?: .+$"` | no |
| <a name="input_default_branch"></a> [default\_branch](#input\_default\_branch) | Default branch name for the repository. | `string` | `"main"` | no |
| <a name="input_dev_env_reviewers"></a> [dev\_env\_reviewers](#input\_dev\_env\_reviewers) | List of GitHub usernames who can review development deployments. (Currently not implemented - GitHub API requires numeric user IDs) | `list(string)` | `[]` | no |
| <a name="input_develop_branch_name"></a> [develop\_branch\_name](#input\_develop\_branch\_name) | Name of the develop/integration branch. | `string` | `"develop"` | no |
| <a name="input_develop_branch_overrides"></a> [develop\_branch\_overrides](#input\_develop\_branch\_overrides) | Override settings for develop branch ruleset. | `map(any)` | `{}` | no |
| <a name="input_develop_branch_require_signed_commits"></a> [develop\_branch\_require\_signed\_commits](#input\_develop\_branch\_require\_signed\_commits) | Require signed commits on develop branch. | `bool` | `false` | no |
| <a name="input_develop_branch_status_checks"></a> [develop\_branch\_status\_checks](#input\_develop\_branch\_status\_checks) | Required status checks for develop branch. | `list(string)` | `[]` | no |
| <a name="input_dismiss_stale_reviews"></a> [dismiss\_stale\_reviews](#input\_dismiss\_stale\_reviews) | Dismiss stale reviews when new commits are pushed. | `bool` | `true` | no |
| <a name="input_enable_advanced_security"></a> [enable\_advanced\_security](#input\_enable\_advanced\_security) | Enable GitHub Advanced Security features. | `bool` | `false` | no |
| <a name="input_enable_codeowners_file"></a> [enable\_codeowners\_file](#input\_enable\_codeowners\_file) | Create and manage a CODEOWNERS file. | `bool` | `true` | no |
| <a name="input_enable_dependabot_security_updates"></a> [enable\_dependabot\_security\_updates](#input\_enable\_dependabot\_security\_updates) | Enable Dependabot security updates. | `bool` | `true` | no |
| <a name="input_enable_dev_environment"></a> [enable\_dev\_environment](#input\_enable\_dev\_environment) | Enable development environment. | `bool` | `true` | no |
| <a name="input_enable_develop_branch"></a> [enable\_develop\_branch](#input\_enable\_develop\_branch) | Create and manage the develop branch (automatically enabled when enable\_gitflow is true). | `bool` | `true` | no |
| <a name="input_enable_feature_branches"></a> [enable\_feature\_branches](#input\_enable\_feature\_branches) | Enable feature branch protection rules. | `bool` | `true` | no |
| <a name="input_enable_gitflow"></a> [enable\_gitflow](#input\_enable\_gitflow) | Enable full GitFlow workflow (develop/release/hotfix branches). Set to false for trunk-based development. | `bool` | `true` | no |
| <a name="input_enable_hotfix_branches"></a> [enable\_hotfix\_branches](#input\_enable\_hotfix\_branches) | Enable hotfix branch protection rules. | `bool` | `true` | no |
| <a name="input_enable_prod_environment"></a> [enable\_prod\_environment](#input\_enable\_prod\_environment) | Enable production environment. | `bool` | `true` | no |
| <a name="input_enable_push_rules"></a> [enable\_push\_rules](#input\_enable\_push\_rules) | Enable push rules to restrict file types and sizes. | `bool` | `true` | no |
| <a name="input_enable_release_branches"></a> [enable\_release\_branches](#input\_enable\_release\_branches) | Enable release branch protection rules. | `bool` | `true` | no |
| <a name="input_enable_secret_scanning"></a> [enable\_secret\_scanning](#input\_enable\_secret\_scanning) | Enable secret scanning. | `bool` | `false` | no |
| <a name="input_enable_secret_scanning_push_protection"></a> [enable\_secret\_scanning\_push\_protection](#input\_enable\_secret\_scanning\_push\_protection) | Enable secret scanning push protection. | `bool` | `false` | no |
| <a name="input_enable_stage_environment"></a> [enable\_stage\_environment](#input\_enable\_stage\_environment) | Enable staging environment. | `bool` | `true` | no |
| <a name="input_enable_tag_protection"></a> [enable\_tag\_protection](#input\_enable\_tag\_protection) | Enable tag protection for release tags. | `bool` | `true` | no |
| <a name="input_enable_webhook"></a> [enable\_webhook](#input\_enable\_webhook) | Enable GitFlow automation webhook. | `bool` | `false` | no |
| <a name="input_github_base_url"></a> [github\_base\_url](#input\_github\_base\_url) | GitHub base URL for GitHub Enterprise Server. Leave null for github.com. | `string` | `null` | no |
| <a name="input_github_max_retries"></a> [github\_max\_retries](#input\_github\_max\_retries) | Maximum number of retries for a request. | `number` | `3` | no |
| <a name="input_github_owner"></a> [github\_owner](#input\_github\_owner) | GitHub user or organisation that owns the repository. | `string` | n/a | yes |
| <a name="input_github_read_delay_ms"></a> [github\_read\_delay\_ms](#input\_github\_read\_delay\_ms) | Time in milliseconds to sleep between reads to avoid rate limiting. | `number` | `0` | no |
| <a name="input_github_retry_delay_ms"></a> [github\_retry\_delay\_ms](#input\_github\_retry\_delay\_ms) | Time in milliseconds to sleep before retrying a request. | `number` | `1000` | no |
| <a name="input_github_retry_max_delay_ms"></a> [github\_retry\_max\_delay\_ms](#input\_github\_retry\_max\_delay\_ms) | Maximum time in milliseconds to sleep before retrying a request. | `number` | `30000` | no |
| <a name="input_github_token"></a> [github\_token](#input\_github\_token) | PAT with repo/admin:org scope. Leave unset → use GITHUB\_TOKEN env. | `string` | `null` | no |
| <a name="input_github_write_delay_ms"></a> [github\_write\_delay\_ms](#input\_github\_write\_delay\_ms) | Time in milliseconds to sleep between writes to avoid rate limiting. | `number` | `1000` | no |
| <a name="input_hotfix_branch_require_signed_commits"></a> [hotfix\_branch\_require\_signed\_commits](#input\_hotfix\_branch\_require\_signed\_commits) | Require signed commits on hotfix branches. | `bool` | `true` | no |
| <a name="input_hotfix_branch_status_checks"></a> [hotfix\_branch\_status\_checks](#input\_hotfix\_branch\_status\_checks) | Required status checks for hotfix branches. | `list(string)` | `[]` | no |
| <a name="input_main_branch_name"></a> [main\_branch\_name](#input\_main\_branch\_name) | Name of the main/production branch. | `string` | `"main"` | no |
| <a name="input_main_branch_overrides"></a> [main\_branch\_overrides](#input\_main\_branch\_overrides) | Override settings for main branch ruleset. | `map(any)` | `{}` | no |
| <a name="input_main_branch_require_signed_commits"></a> [main\_branch\_require\_signed\_commits](#input\_main\_branch\_require\_signed\_commits) | Require signed commits on main branch. | `bool` | `true` | no |
| <a name="input_main_branch_status_checks"></a> [main\_branch\_status\_checks](#input\_main\_branch\_status\_checks) | Required status checks for main branch. | `list(string)` | `[]` | no |
| <a name="input_manage_topics_in_terraform"></a> [manage\_topics\_in\_terraform](#input\_manage\_topics\_in\_terraform) | Whether to manage repository topics in Terraform (true) or allow manual UI edits (false). | `bool` | `false` | no |
| <a name="input_max_file_path_length"></a> [max\_file\_path\_length](#input\_max\_file\_path\_length) | Maximum file path length for push rules (0 = disabled). | `number` | `0` | no |
| <a name="input_max_file_size_mb"></a> [max\_file\_size\_mb](#input\_max\_file\_size\_mb) | Maximum file size in MB for push rules. | `number` | `5` | no |
| <a name="input_prod_env_reviewers"></a> [prod\_env\_reviewers](#input\_prod\_env\_reviewers) | List of GitHub usernames who can review production deployments. (Currently not implemented - GitHub API requires numeric user IDs) | `list(string)` | `[]` | no |
| <a name="input_release_branch_require_signed_commits"></a> [release\_branch\_require\_signed\_commits](#input\_release\_branch\_require\_signed\_commits) | Require signed commits on release branches. | `bool` | `true` | no |
| <a name="input_release_branch_status_checks"></a> [release\_branch\_status\_checks](#input\_release\_branch\_status\_checks) | Required status checks for release branches. | `list(string)` | `[]` | no |
| <a name="input_repo_allow_merge_commit"></a> [repo\_allow\_merge\_commit](#input\_repo\_allow\_merge\_commit) | Allow merge commits for pull requests. | `bool` | `true` | no |
| <a name="input_repo_allow_rebase_merge"></a> [repo\_allow\_rebase\_merge](#input\_repo\_allow\_rebase\_merge) | Allow rebase merging for pull requests. | `bool` | `true` | no |
| <a name="input_repo_allow_squash_merge"></a> [repo\_allow\_squash\_merge](#input\_repo\_allow\_squash\_merge) | Allow squash merging for pull requests. | `bool` | `true` | no |
| <a name="input_repo_has_projects"></a> [repo\_has\_projects](#input\_repo\_has\_projects) | Enable repository projects. | `bool` | `false` | no |
| <a name="input_repo_has_wiki"></a> [repo\_has\_wiki](#input\_repo\_has\_wiki) | Enable repository wiki. | `bool` | `false` | no |
| <a name="input_repository_name"></a> [repository\_name](#input\_repository\_name) | Name of the repository to manage. | `string` | n/a | yes |
| <a name="input_repository_topics"></a> [repository\_topics](#input\_repository\_topics) | Optional list of repository topics to manage when manage\_topics\_in\_terraform is true. | `list(string)` | `[]` | no |
| <a name="input_repository_visibility"></a> [repository\_visibility](#input\_repository\_visibility) | Repository visibility: public, private, or internal. | `string` | `"private"` | no |
| <a name="input_require_code_owner_reviews"></a> [require\_code\_owner\_reviews](#input\_require\_code\_owner\_reviews) | Require code owner reviews. | `bool` | `false` | no |
| <a name="input_require_last_push_approval"></a> [require\_last\_push\_approval](#input\_require\_last\_push\_approval) | Require approval from someone other than the last pusher. | `bool` | `false` | no |
| <a name="input_required_workflows"></a> [required\_workflows](#input\_required\_workflows) | List of required GitHub Actions workflows that must pass. | <pre>list(object({<br/>    path       = string<br/>    repository = string<br/>    ref        = optional(string, "main")<br/>  }))</pre> | `[]` | no |
| <a name="input_restricted_file_extensions"></a> [restricted\_file\_extensions](#input\_restricted\_file\_extensions) | File extensions to restrict in push rules. | `list(string)` | `[]` | no |
| <a name="input_restricted_file_paths"></a> [restricted\_file\_paths](#input\_restricted\_file\_paths) | File paths to restrict in push rules (using fnmatch patterns). | `list(string)` | `[]` | no |
| <a name="input_set_develop_as_default"></a> [set\_develop\_as\_default](#input\_set\_develop\_as\_default) | Set develop branch as the default branch (not recommended for GitFlow). | `bool` | `false` | no |
| <a name="input_stage_env_reviewers"></a> [stage\_env\_reviewers](#input\_stage\_env\_reviewers) | List of GitHub usernames who can review staging deployments. (Currently not implemented - GitHub API requires numeric user IDs) | `list(string)` | `[]` | no |
| <a name="input_webhook_events"></a> [webhook\_events](#input\_webhook\_events) | List of events to trigger webhook. | `list(string)` | <pre>[<br/>  "push",<br/>  "pull_request",<br/>  "release"<br/>]</pre> | no |
| <a name="input_webhook_insecure_ssl"></a> [webhook\_insecure\_ssl](#input\_webhook\_insecure\_ssl) | Allow insecure SSL for webhook. | `bool` | `false` | no |
| <a name="input_webhook_secret"></a> [webhook\_secret](#input\_webhook\_secret) | Webhook secret for GitFlow automation. | `string` | `""` | no |
| <a name="input_webhook_url"></a> [webhook\_url](#input\_webhook\_url) | Webhook URL for GitFlow automation. | `string` | `""` | no |

## Outputs

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_branch_rulesets"></a> [branch\_rulesets](#output\_branch\_rulesets) | Map of all branch rulesets with their IDs and enforcement status. |
| <a name="output_develop_branch_name"></a> [develop\_branch\_name](#output\_develop\_branch\_name) | Name of the develop branch (null if disabled). |
| <a name="output_develop_branch_ruleset_id"></a> [develop\_branch\_ruleset\_id](#output\_develop\_branch\_ruleset\_id) | Ruleset ID for the develop branch (null if disabled). |
| <a name="output_environments"></a> [environments](#output\_environments) | Map of all environments with their URLs and settings. |
| <a name="output_gitflow_configuration"></a> [gitflow\_configuration](#output\_gitflow\_configuration) | Complete GitFlow configuration summary. |
| <a name="output_main_branch_name"></a> [main\_branch\_name](#output\_main\_branch\_name) | Name of the main branch. |
| <a name="output_main_branch_ruleset_id"></a> [main\_branch\_ruleset\_id](#output\_main\_branch\_ruleset\_id) | Ruleset ID for the main branch. |
| <a name="output_push_rules_ruleset_id"></a> [push\_rules\_ruleset\_id](#output\_push\_rules\_ruleset\_id) | Ruleset ID for push restrictions (not yet supported by provider). |
| <a name="output_repository_clone_url"></a> [repository\_clone\_url](#output\_repository\_clone\_url) | Clone URL for the repository. |
| <a name="output_repository_html_url"></a> [repository\_html\_url](#output\_repository\_html\_url) | Link to the GitHub repository. |
| <a name="output_repository_ssh_clone_url"></a> [repository\_ssh\_clone\_url](#output\_repository\_ssh\_clone\_url) | SSH clone URL for the repository. |
| <a name="output_security_features"></a> [security\_features](#output\_security\_features) | Status of all security features enabled on the repository. |
| <a name="output_tag_protection_ruleset_id"></a> [tag\_protection\_ruleset\_id](#output\_tag\_protection\_ruleset\_id) | Ruleset ID for tag protection (null if disabled). |
<!-- END_TF_DOCS -->

output-values:
  enabled: false
  from: ""

sort:
  enabled: true
  by: name

settings:
  anchor: true
  color: true
  default: true
  description: false
  escape: true
  hide-empty: false
  html: true
  indent: 2
  lockfile: true
  read-comments: true
  required: true
  sensitive: true
  type: true
```

## Content Template

Generated content can be customized further away with `content` in configuration.
If the `content` is empty the default order of sections is used.

Compatible formatters for customized content are `asciidoc` and `markdown`. `content`
will be ignored for other formatters.

`content` is a Go template with following additional variables:

- `{{ .Header }}`
- `{{ .Footer }}`
- `{{ .Inputs }}`
- `{{ .Modules }}`
- `{{ .Outputs }}`
- `{{ .Providers }}`
- `{{ .Requirements }}`
- `{{ .Resources }}`

and following functions:

- `{{ include "relative/path/to/file" }}`

These variables are the generated output of individual sections in the selected
formatter. For example `{{ .Inputs }}` is Markdown Table representation of _inputs_
when formatter is set to `markdown table`.

Note that sections visibility (i.e. `sections.show` and `sections.hide`) takes
precedence over the `content`.

Additionally there's also one extra special variable avaialble to the `content`:

- `{{ .Module }}`

As opposed to the other variables mentioned above, which are generated sections
based on a selected formatter, the `{{ .Module }}` variable is just a `struct`
representing a [Terraform module].

````yaml
content: |-
  Any arbitrary text can be placed anywhere in the content

  {{ .Header }}

  and even in between sections

  {{ .Providers }}

  and they don't even need to be in the default order

  {{ .Outputs }}

  include any relative files

  {{ include "relative/path/to/file" }}

  {{ .Inputs }}

  # Examples

  ```hcl
  {{ include "examples/foo/main.tf" }}
  ```

  ## Resources

  {{ range .Module.Resources }}
  - {{ .GetMode }}.{{ .Spec }} ({{ .Position.Filename }}#{{ .Position.Line }})
  {{- end }}
````

## Build on top of terraform-docs

terraform-docs primary use-case is to be utilized as a standalone binary, but
some parts of it is also available publicly and can be imported in your project
as a library.

```go
import (
    "github.com/terraform-docs/terraform-docs/format"
    "github.com/terraform-docs/terraform-docs/print"
    "github.com/terraform-docs/terraform-docs/terraform"
)

// buildTerraformDocs for module root `path` and provided content `tmpl`.
func buildTerraformDocs(path string, tmpl string) (string, error) {
    config := print.DefaultConfig()
    config.ModuleRoot = path // module root path (can be relative or absolute)

    module, err := terraform.LoadWithOptions(config)
    if err != nil {
        return "", err
    }

    // Generate in Markdown Table format
    formatter := format.NewMarkdownTable(config)

    if err := formatter.Generate(module); err != nil {
        return "", err
    }

    // // Note: if you don't intend to provide additional template for the generated
    // // content, or the target format doesn't provide templating (e.g. json, yaml,
    // // xml, or toml) you can use `Content()` function instead of `Render()`.
    // // `Content()` returns all the sections combined with predefined order.
    // return formatter.Content(), nil

    return formatter.Render(tmpl)
}
```

## Plugin

Generated output can be heavily customized with [`content`], but if using that
is not enough for your use-case, you can write your own plugin.

In order to install a plugin the following steps are needed:

- download the plugin and place it in `~/.tfdocs.d/plugins` (or `./.tfdocs.d/plugins`)
- make sure the plugin file name is `tfdocs-format-<NAME>`
- modify [`formatter`] of `.terraform-docs.yml` file to be `<NAME>`

**Important notes:**

- if the plugin file name is different than the example above, terraform-docs won't
be able to to pick it up nor register it properly
- you can only use plugin thorough `.terraform-docs.yml` file and it cannot be used
with CLI arguments

To create a new plugin create a new repository called `tfdocs-format-<NAME>` with
following `main.go`:

```go
package main

import (
    _ "embed" //nolint

    "github.com/terraform-docs/terraform-docs/plugin"
    "github.com/terraform-docs/terraform-docs/print"
    "github.com/terraform-docs/terraform-docs/template"
    "github.com/terraform-docs/terraform-docs/terraform"
)

func main() {
    plugin.Serve(&plugin.ServeOpts{
        Name:    "<NAME>",
        Version: "0.1.0",
        Printer: printerFunc,
    })
}

//go:embed sections.tmpl
var tplCustom []byte

// printerFunc the function being executed by the plugin client.
func printerFunc(config *print.Config, module *terraform.Module) (string, error) {
    tpl := template.New(config,
        &template.Item{Name: "custom", Text: string(tplCustom)},
    )

    rendered, err := tpl.Render("custom", module)
    if err != nil {
        return "", err
    }

    return rendered, nil
}
```

Please refer to [tfdocs-format-template] for more details. You can create a new
repository from it by clicking on `Use this template` button.

## Documentation

- **Users**
  - Read the [User Guide] to learn how to use terraform-docs
  - Read the [Formats Guide] to learn about different output formats of terraform-docs
  - Refer to [Config File Reference] for all the available configuration options
- **Developers**
  - Read [Contributing Guide] before submitting a pull request

Visit [our website] for all documentation.

## Community

- Discuss terraform-docs on [Slack]

## License

MIT License - Copyright (c) 2021 The terraform-docs Authors.

[Chocolatey]: https://www.chocolatey.org
[Config File Reference]: https://terraform-docs.io/user-guide/configuration/
[`content`]: https://terraform-docs.io/user-guide/configuration/content/
[Contributing Guide]: CONTRIBUTING.md
[Formats Guide]: https://terraform-docs.io/reference/terraform-docs/
[`formatter`]: https://terraform-docs.io/user-guide/configuration/formatter/
[here]: https://golang.org/doc/code.html#GOPATH
[Homebrew]: https://brew.sh
[install pre-commit]: https://pre-commit.com/#install
[`output`]: https://terraform-docs.io/user-guide/configuration/output/
[releases]: https://github.com/terraform-docs/terraform-docs/releases
[Scoop]: https://scoop.sh/
[Slack]: https://slack.terraform-docs.io/
[terraform-docs GitHub Action]: https://github.com/terraform-docs/gh-actions
[Terraform module]: https://pkg.go.dev/github.com/terraform-docs/terraform-docs/terraform#Module
[tfdocs-format-template]: https://github.com/terraform-docs/tfdocs-format-template
[our website]: https://terraform-docs.io/
[User Guide]: https://terraform-docs.io/user-guide/introduction/

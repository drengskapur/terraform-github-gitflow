# TFLint configuration for Terraform modules

plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

# plugin "aws" {
#   enabled = true
#   version = "0.40.0"
#   source  = "github.com/terraform-linters/tflint-ruleset-aws"
# }

# plugin "azurerm" {
#   enabled = true
#   version = "0.28.0"
#   source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
# }

# plugin "google" {
#   enabled = true
#   version = "0.32.0"
#   source  = "github.com/terraform-linters/tflint-ruleset-google"
# }

# Ensure all variables have descriptions
rule "terraform_documented_variables" {
  enabled = true
}

# Ensure all outputs have descriptions
rule "terraform_documented_outputs" {
  enabled = true
}

# Ensure variables have types
rule "terraform_typed_variables" {
  enabled = true
}

# Naming conventions
rule "terraform_naming_convention" {
  enabled = true
  format  = "snake_case"
}

# Ensure no deprecated interpolations
rule "terraform_deprecated_interpolation" {
  enabled = true
}

# Check for unused declarations
# Disabled for reusable modules - variables are part of the public API
# and may not be used in examples but are intended for end users
rule "terraform_unused_declarations" {
  enabled = false
}

# Require terraform block with required_version
rule "terraform_required_version" {
  enabled = true
}

# Require provider version constraints
rule "terraform_required_providers" {
  enabled = true
}

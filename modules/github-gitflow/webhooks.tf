###############################################################################
# Optional webhooks for GitFlow automation
###############################################################################

resource "github_repository_webhook" "gitflow" {
  count      = var.enable_webhook ? 1 : 0
  repository = github_repository.this.name

  configuration {
    url          = var.webhook_url
    content_type = "json"
    secret       = var.webhook_secret
    insecure_ssl = var.webhook_insecure_ssl
  }

  events = var.webhook_events
  active = true
} 
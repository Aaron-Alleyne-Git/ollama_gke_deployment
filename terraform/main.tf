module "tailscale_operator" {
  source = "./modules/tailscale-operator"
  
  oauth_client_id     = var.ts_oauth_client_id
  oauth_client_secret = var.ts_oauth_client_secret
  default_tags        = ["tag:k8s", "tag:production"]
  enable_metrics      = true
}
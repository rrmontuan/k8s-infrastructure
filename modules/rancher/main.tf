# Rancher resources

# Initialize Rancher server
resource "rancher2_bootstrap" "admin" {
  provider = rancher2.bootstrap

  password  = var.admin_password
  telemetry = true
}

resource "rancher2_cluster" "cluster" {
  provider = rancher2.admin

  name = "curso"
  rke_config {
    ingress {
      default_backend = false
    }
  }
}
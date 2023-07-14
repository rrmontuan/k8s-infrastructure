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
      provider = "none"
    }
  }
}

resource "ssh_resource" "create_kubectl_config" {
  host        = var.node_public_ip
  user        = var.node_username
  private_key = var.ssh_private_key_pem

  file {
    content     = rancher2_cluster.cluster.kube_config
    destination = "/home/ubuntu/.kube/config"
    permissions = "0640"
  }
}

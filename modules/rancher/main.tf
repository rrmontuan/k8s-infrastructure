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

resource "rancher2_cluster_sync" "cluster_sync" {
  depends_on = [var.nodes_dns]
  provider = rancher2.admin
  cluster_id =  rancher2_cluster.cluster.id
}

resource "ssh_resource" "create_kubectl_config" {
  host        = var.node_public_ip
  user        = var.node_username
  private_key = var.ssh_private_key_pem

  file {
    content     = rancher2_cluster_sync.cluster_sync.kube_config
    destination = "/home/ubuntu/.kube/config"
    permissions = "0640"
  }
}

resource "ssh_resource" "install_traefik_ingress" {
  depends_on = [ssh_resource.create_kubectl_config]
  host        = var.node_public_ip
  user        = var.node_username
  private_key = var.ssh_private_key_pem

  file {
    content     = templatefile(
      "${path.module}/files/traefik_ui.template",
      {
        domain = var.domain
      }
    )
    destination = "/home/ubuntu/k8s_files/traefik_ui.yml"
    permissions = "0640"
  }

  commands = [
    "kubectl apply -f https://raw.githubusercontent.com/containous/traefik/v1.7/examples/k8s/traefik-rbac.yaml",
    "kubectl apply -f https://raw.githubusercontent.com/containous/traefik/v1.7/examples/k8s/traefik-ds.yaml",
    "kubectl apply -f /home/ubuntu/k8s_files/traefik_ui.yml"
  ]
}

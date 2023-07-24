resource "tls_private_key" "global_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_sensitive_file" "ssh_private_key_pem" {
  filename        = "${path.root}/keys/rancher"
  content         = tls_private_key.global_key.private_key_pem
  file_permission = "0600"
}

resource "local_file" "ssh_public_key_openssh" {
  filename = "${path.root}/keys/rancher.pub"
  content  = tls_private_key.global_key.public_key_openssh
}

resource "aws_key_pair" "ec2_key" {
  key_name   = "ec2_key"
  public_key = tls_private_key.global_key.public_key_openssh

  tags = {
    Name        = "${var.environment}-ec2-key"
    Environment = var.environment
  }
}

resource "aws_instance" "server" {
  depends_on = [
    var.aws_route_table_association
  ]
  ami                         = "ami-0dce57edaf582cf62" #Ubuntu 20.04 LTS
  instance_type               = "t3.medium"
  vpc_security_group_ids      = var.ec2_security_group_ids
  user_data                   = templatefile(
    "${path.module}/files/userdata_rancher_server.template",
    {
      rancher_version = var.rancher_version
    }
  )
  key_name                    = "ec2_key"
  subnet_id                   = var.subnet.id
  associate_public_ip_address = true
  
  metadata_options {
    http_endpoint = "enabled"
    instance_metadata_tags = "enabled"
  }

  root_block_device {
    volume_size = 30
    volume_type = "standard"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'",
    ]

    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = local.node_username
      private_key = tls_private_key.global_key.private_key_pem
    }
  }

  tags = {
    Name        = "${var.environment}-rancher-server"
    Environment = var.environment
  }
}

# Rancher resources
module "rancher_common" {
  source = "../rancher"

  node_public_ip              = aws_instance.server.public_ip
  node_internal_ip            = aws_instance.server.private_ip
  node_username               = local.node_username
  ssh_private_key_pem         = tls_private_key.global_key.private_key_pem
  rancher_server_dns          = var.rancher_server_dns 
  nodes_dns                   = var.nodes_dns
  domain                      = var.domain                   
  admin_password              = var.rancher_server_admin_password
  workload_cluster_name       = "curso"
}

resource "aws_instance" "nodes" {
  depends_on = [
    var.aws_route_table_association
  ]

  ami                     = "ami-0dce57edaf582cf62" #Ubuntu 20.04 LTS
  instance_type           = "t3.medium"
  count                   = length(var.cluster_nodes)
  vpc_security_group_ids  = var.ec2_security_group_ids
  associate_public_ip_address = true
  user_data = templatefile(
    "${path.module}/files/userdata_quickstart_node.template",
    {
      register_command = module.rancher_common.custom_cluster_command
    }
  )
  key_name                = "ec2_key"
  subnet_id               = var.subnet.id

  metadata_options {
    http_endpoint = "enabled"
    instance_metadata_tags = "enabled"
  }

  root_block_device {
    volume_size = 30
    volume_type = "standard"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'",
    ]

    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = local.node_username
      private_key = tls_private_key.global_key.private_key_pem
    }
  }

  tags = {
    Name        = "${var.environment}-${element(var.cluster_nodes, count.index)}"
    Environment = var.environment
  }
}

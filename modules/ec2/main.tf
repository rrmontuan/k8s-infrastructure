resource "aws_key_pair" "ec2_key" {
  key_name   = "ec2_key"
  public_key = var.public_key

  tags = {
    Name        = "${var.environment}-ec2-key"
    Environment = var.environment
  }
}

resource "aws_instance" "nodes" {
  ami                     = "ami-0dce57edaf582cf62" #Ubuntu 20.04 LTS
  instance_type           = "t3.medium"
  count                   = length(var.cluster_nodes)
  vpc_security_group_ids  = var.ec2_security_group_ids
  user_data               = file("${path.module}/scripts/nodes.sh")
  key_name                = "ec2_key"
  subnet_id               = var.subnet.id

  root_block_device {
    volume_size = 30
    volume_type = "standard"
  }

  tags = {
    Name        = "${var.environment}-${element(var.cluster_nodes, count.index)}"
    Environment = var.environment
  }
}

resource "aws_instance" "server" {
  ami                     = "ami-0dce57edaf582cf62" #Ubuntu 20.04 LTS
  instance_type           = "t3.medium"
  vpc_security_group_ids  = var.ec2_security_group_ids
  user_data               = file("${path.module}/scripts/rancher_server.sh")
  key_name                = "ec2_key"
  subnet_id               = var.subnet.id

  root_block_device {
    volume_size = 30
    volume_type = "standard"
  }

  tags = {
    Name        = "${var.environment}-rancher-server"
    Environment = var.environment
  }
}

resource "aws_eip" "eip_nodes" {
  vpc       = true
  instance  = element(aws_instance.nodes.*.id, count.index)
  count     = length(aws_instance.nodes)

  tags = {
    Environment = var.environment
  }
}

resource "aws_eip" "eip_server" {
  instance = aws_instance.server.id
  vpc      = true

  tags = {
    Environment = var.environment
  }
}

resource "aws_security_group" "allow_efs" {
  name        = "allow_efs"
  description = "Allow EFS access"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    self      = true
  }

  tags {
    Name       = "allow_efs"
    managed_by = "Terraform"
  }
}

resource "aws_security_group" "mount_target_sg" {
  name        = "inbound_nfs"
  description = "Allow NFS (EFS) access inbound"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = ["${aws_security_group.allow_efs.id}"]
  }

  tags {
    Name       = "inbound_nfs"
    managed_by = "Terraform"
  }
}

resource "aws_efs_mount_target" "homedir_mountpoint_a" {
  file_system_id  = "${var.efs_id}"
  subnet_id       = "${var.subnet_id}"
  security_groups = ["${aws_security_group.mount_target_sg.id}"]
}

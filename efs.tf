resource "aws_security_group" "allow_efs" {
  name = "allow_efs"
  description = "Allow EFS access"
  vpc_id =  "${var.myvpc_id}"
  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      self = true
  }

  tags {
    Name = "allow_efs"
  }
}

resource "aws_security_group" "mount_target_sg" {
  name = "inbound_nfs"
  description = "Allow NFS (EFS) access inbound"
  vpc_id = "${var.myvpc_id}"
  ingress {
      from_port = 2049
      to_port = 2049
      protocol = "tcp"
      security_groups = ["${aws_security_group.allow_efs.id}"]
  }

  tags {
    Name = "inbound_nfs"
  }
}

resource "aws_efs_file_system" "homedirs" {
  tags = {
    Name = "HomeDirs"
    project = "niddel"
  }
  lifecycle { prevent_destroy = true }
}

resource "aws_efs_mount_target" "homedir_mountpoint_a" {
  file_system_id = "${aws_efs_file_system.homedirs.id}"
  subnet_id = "${var.mysubnet_id}"
  security_groups = ["${aws_security_group.mount_target_sg.id}"]
}

output "allow_efs" {
  value = "${aws_security_group.allow_efs.id}"
}

output "mount_target_sg" {
  value = "${aws_security_group.mount_target_sg.id}"
}

output "fs_id" {
  value = "${aws_efs_file_system.homedirs.id}"
}

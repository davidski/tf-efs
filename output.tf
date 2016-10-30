output "allow_efs" {
  value = "${aws_security_group.allow_efs.id}"
}

output "mount_target_sg" {
  value = "${aws_security_group.mount_target_sg.id}"
}

output "fs_id" {
  value = "${aws_efs_file_system.homedirs.id}"
}

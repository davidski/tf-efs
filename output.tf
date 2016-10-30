output "allow_efs" {
  value = "${aws_security_group.allow_efs.id}"
}

output "mount_target_sg" {
  value = "${aws_security_group.mount_target_sg.id}"
}

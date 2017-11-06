/*
// External SSH allows ssh connections on port 22 from the world.
output "external_ssh" {
  value = "${aws_security_group.external_ssh.id}"
}
*/
/*
// Internal SSH allows ssh connections from the external ssh security group.
output "internal_ssh" {
  value = "${aws_security_group.internal_ssh.id}"
}
*/
// Internal ELB allows internal traffic.
output "internal_elb" {
  value = "${aws_security_group.internal_elb.id}"
}

// External ELB allows traffic from the world.
output "external_elb" {
  value = "${aws_security_group.external_elb.id}"
}

// Security Groups defined
output "security_group_ids" {
  #value = "${aws_security_group.internal_elb.id},${aws_security_group.external_elb.id},${aws_security_group.internal_ssh.id},${aws_security_group.external_ssh.id}"
  value = "${aws_security_group.internal_elb.id},${aws_security_group.external_elb.id}"
}

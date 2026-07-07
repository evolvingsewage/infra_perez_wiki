output "github_actions_role_arn" {
  value = aws_iam_role.github_actions_jenkins.arn
}

output "jenkins_instance_profile_name" {
  value = aws_iam_instance_profile.jenkins.name
}

output "jenkins_instance_role_arn" {
  value = aws_iam_role.jenkins_instance.arn
}

output "jenkins_eip_allocation_id" {
  value = aws_eip.jenkins.allocation_id
}

output "jenkins_eip_public_ip" {
  value = aws_eip.jenkins.public_ip
}

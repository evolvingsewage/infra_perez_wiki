output "instance_id" {
  value = aws_instance.jenkins.id
}

# The stable EIP, not the instance's auto-assigned IP (which changes each
# -replace). Reflects the address once eip_association attaches it.
output "public_ip" {
  value = data.terraform_remote_state.iam.outputs.jenkins_eip_public_ip
}

output "jenkins_url" {
  value = "http://${data.terraform_remote_state.iam.outputs.jenkins_eip_public_ip}:8080"
}

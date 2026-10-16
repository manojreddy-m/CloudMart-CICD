output "aws_region" {
  value = var.aws_region
}

output "vpc_id" {
  description = "ID of the VPC created for CloudMart"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "jenkins_instance_id" {
  value = aws_instance.jenkins.id
}

output "jenkins_public_ip" {
  value = aws_instance.jenkins.public_ip
}

output "jenkins_url" {
  value = "http://${aws_instance.jenkins.public_ip}:8080"
}

output "s3_artifacts_bucket" {
  value = aws_s3_bucket.artifacts.bucket
}


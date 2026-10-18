
resource "aws_ecr_repository" "cloudmart" {
  name                 = "cloudmart"
  image_tag_mutability = "MUTABLE"
  force_delete         = false

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "cloudmart"
    Project     = var.project_name
    Environment = var.environment
  }
}




resource "aws_iam_role_policy" "jenkins_ecr_push" {
  name = "cloudmart-jenkins-ecr-push"
  role = var.jenkins_role_name

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:DescribeRepositories",
          "ecr:BatchCheckLayerAvailability",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage"
        ]
        Resource = aws_ecr_repository.cloudmart.arn
      }
    ]
  })
}

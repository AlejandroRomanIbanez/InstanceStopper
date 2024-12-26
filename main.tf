provider "aws" {
  region = "eu-central-1"
}

# IAM Role for CostManager
resource "aws_iam_role" "cost_manager_role" {
  name = "CostManager"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${var.lambda_account_id}:role/LabdaStudentAccess"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Policy to Allow Stopping EC2 and RDS Instances
resource "aws_iam_policy" "ec2_stop_policy" {
  name        = "EC2StopPolicy"
  description = "Policy to allow stopping EC2 and RDS instances"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ec2:DescribeInstances",
          "ec2:StopInstances",
          "rds:DescribeDBInstances",
          "rds:StopDBInstance"
        ],
        Resource = "*"
      }
    ]
  })
}

# Attach Policy to the Role
resource "aws_iam_role_policy_attachment" "cost_manager_attach_policy" {
  role       = aws_iam_role.cost_manager_role.name
  policy_arn = aws_iam_policy.ec2_stop_policy.arn
}

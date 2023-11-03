resource "aws_iam_instance_profile" "hp" {
  name = "hp-instance-profile"
  role = aws_iam_role.hp.name
}

resource "aws_iam_policy" "custom_policy" {
  name        = "hp-ec2-policy"
  description = "Custom policy for EC2 instances"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = "ec2:*",
        Effect   = "Allow",
        Resource = "*",
      },
    ],
  })
}

resource "aws_iam_policy" "custom_policy_s3" {
  name        = "hp-s3-policy"
  description = "Custom policy for EC2 instances"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = "s3:*",
        Effect   = "Allow",
        Resource = "*",
      },
    ],
  })
}

resource "aws_iam_role" "hp" {
  name = "hp-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com",
        },
      },
    ],
  })
}

resource "aws_iam_policy_attachment" "hp" {
  name       = "hp-policy-attachment"
  policy_arn = aws_iam_policy.custom_policy.arn, aws_iam_policy.custom_policy_s3.arn
  roles      = [aws_iam_role.hp.name]
}

resource "aws_iam_policy_attachment" "hp_s3" {
  name       = "hp-policy-attachment"
  policy_arn = aws_iam_policy.custom_policy_s3.arn
  roles      = [aws_iam_role.hp.name]
}

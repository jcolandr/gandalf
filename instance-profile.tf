resource "aws_iam_instance_profile" "hp" {
  name = "hp-instance-profile"
}


resource "aws_iam_instance_profile_role_attachment" "hp" {
  instance_profile = aws_iam_instance_profile.hp.name
  role            = aws_iam_role.hp.name
}



resource "aws_iam_role" "hp" {
  name               = "yak_role"
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json # (not shown)

  inline_policy {
    name = "my_inline_policy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["ec2:*"]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }

}

data "aws_ecr_repository" "rgs_classification" {
  count = "${local.name_prefix == "dd" ? 1 : 0}"

  name = "${var.ecr_repo_name}"
}

resource "aws_ecr_repository_policy" "repository_policy" {
  count = "${local.name_prefix == "dd" ? 1 : 0}"

  repository = "${var.ecr_repo_name}"

  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "AllowPullToAllDSCIAccounts",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.accountid}:root",
                "AWS": "arn:aws:iam::131239767718:root",
                "AWS": "arn:aws:iam::809521787705:root"
            },
            "Action": [
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:BatchCheckLayerAvailability"
            ]
        },
        {
          "Sid": "DenyDelete",
          "Effect": "Deny",
          "Principal": "*",
          "Action": [
            "ecr:BatchDeleteImage"
          ]
        }
    ]
}
EOF
}

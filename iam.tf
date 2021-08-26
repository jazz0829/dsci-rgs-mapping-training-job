resource "aws_iam_role" "rgs_classfication_training" {
  name               = "${local.dsci_sagemaker_rgs_classification_training_role}"
  assume_role_policy = "${data.aws_iam_policy_document.rgs_classification_training_assume_policy.json}"
}

resource "aws_iam_role" "invoke_sagemaker_endpoint_role" {
  name               = "${local.dsci_invoke_sagemaker_endpoint_role}"
  assume_role_policy = "${data.aws_iam_policy_document.invoke_sagemaker_endpoint_policy.json}"
}

resource "aws_iam_role_policy" "invoke_sagemaker_endpoint_role_policy" {
  name   = "${local.dsci_invoke_sagemaker_endpoint_role_policy}"
  role   = "${aws_iam_role.invoke_sagemaker_endpoint_role.id}"
  policy = "${data.aws_iam_policy_document.invoke_sagemaker_endpoint_role_policy.json}"
}

resource "aws_iam_role_policy_attachment" "sm_attach" {
  role       = "${aws_iam_role.rgs_classfication_training.name}"
  policy_arn = "${data.aws_iam_policy.sagemaker_full_access.arn}"
}

resource "aws_iam_role_policy" "rolepolicy_trained_model" {
  name = "${local.dsci_dsci_rgs_trained_model_allow_write}"
  role = "${aws_iam_role.rgs_classfication_training.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:ListBucket"
            ],
            "Resource": [
              "${aws_s3_bucket.dsci_rgs_mapping_bucket.arn}",
              "${aws_s3_bucket.dsci_rgs_mapping_bucket.arn}/*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_user" "sagemaker_in_user" {
  name = "${local.dsci_sagemaker_rgsmapping_invoker_for_eol}"

  tags = "${var.default_tags}"
}

resource "aws_iam_user_policy" "in_invoke_policy" {
  name = "${local.dsci_rgsmapping_endpoint_invoke_policy}"
  user = "${aws_iam_user.sagemaker_in_user.name}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowInvokeRgsMappingEndpoint",
            "Effect": "Allow",
            "Action": "sagemaker:InvokeEndpoint",
            "Resource": "arn:aws:sagemaker:${var.region}:${var.accountid}:endpoint/${local.dsci_endpoint_name}"
        }
    ]
}
EOF
}

resource "aws_iam_access_key" "in_invoker_key" {
  user = "${aws_iam_user.sagemaker_in_user.name}"
}

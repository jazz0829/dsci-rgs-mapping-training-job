data "aws_iam_policy_document" "rgs_classification_training_assume_policy" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com", "sagemaker.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "invoke_sagemaker_endpoint_policy" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${var.dsci_trusted_aws_account1_number}:root",
        "arn:aws:iam::${var.dsci_trusted_aws_account2_number}:root",
      ]
    }
  }
}

data "aws_iam_policy_document" "invoke_sagemaker_endpoint_role_policy" {
  statement {
    effect = "Allow"

    actions = [
      "sagemaker:InvokeEndpoint",
    ]

    resources = [
      "arn:aws:sagemaker:*:*:endpoint/${local.name_prefix}-*",
    ]
  }
}

data "aws_iam_policy" "sagemaker_full_access" {
  arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}

resource "aws_iam_role" "state_machine_role" {
  name               = "${local.dsci_rgs_mapping_state_machine_name}-assume-role"
  assume_role_policy = "${data.aws_iam_policy_document.state_machine_assume_role_policy_document.json}"

  tags = "${var.default_tags}"
}

resource "aws_iam_role_policy" "iam_policy_for_state_machine" {
  name   = "${local.dsci_rgs_mapping_state_machine_name}-function-invoke"
  role   = "${aws_iam_role.state_machine_role.id}"
  policy = "${data.aws_iam_policy_document.state_machine_iam_policy_document.json}"
}

data "aws_iam_policy_document" "state_machine_assume_role_policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["states.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "state_machine_iam_policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "lambda:InvokeFunction",
    ]

    resources = [
      "arn:aws:lambda:*:*:function:${local.name_prefix}-dsci-sagemaker-*",
    ]
  }
}

data "template_file" "sfn_definition" {
  template = "${file(var.step_function_definition_file)}"

  vars = {
    dsci-sagemaker-slack-lambda-arn                    = "${data.terraform_remote_state.base_config.lambda_app_notify_slack_arn}"
    dsci-sagemaker-create-model-lambda-arn             = "${data.terraform_remote_state.base_config.lambda_app_create_sagemaker_model_arn}"
    dsci-sagemaker-create-endpoint-config-lambda-arn   = "${data.terraform_remote_state.base_config.lambda_app_create_sagemaker_endpoint_config_arn}"
    dsci-sagemaker-update-endpoint-lambda-arn          = "${data.terraform_remote_state.base_config.lambda_app_update_sagemaker_endpoint_arn}"
    dsci-sagemaker-get-endpoint-status-lambda-arn      = "${data.terraform_remote_state.base_config.lambda_app_get_sagemaker_endpoint_status_arn}"
    dsci-sagemaker-create-cloudwatch-alarms-lambda-arn = "${data.terraform_remote_state.base_config.lambda_app_create_cloudwatch_alarm_sagemaker_arn}"
    dsci-sagemaker-invoke-endpoint-lambda-arn          = "${data.terraform_remote_state.base_config.lambda_app_invoke_sagemaker_endpoint_arn}"
    dsci-sagemaker-bookmark-endpoint-config-arn        = "${data.terraform_remote_state.base_config.lambda_app_bookmark_sagemaker_endpoint_config_arn}"
    dsci-sagemaker-rollback-endpoint-arn               = "${data.terraform_remote_state.base_config.lambda_app_rollback_sagemaker_endpoint_arn}"
    dsci-sagemaker-apply-auto-scaling-arn              = "${data.terraform_remote_state.base_config.lambda_app_sagemaker_apply_auto_scaling_arn}"
  }
}

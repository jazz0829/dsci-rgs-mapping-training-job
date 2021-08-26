data "aws_iam_policy_document" "cloudwatch_assume_role_policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "cloudwatch_start_execution_policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "states:StartExecution",
    ]

    resources = [
      "${var.step_function_arn}",
    ]
  }
}

data "template_file" "event_input" {
  template = "${file(var.start_training_event_input_file)}"

  vars = {
    prediction_image              = "428785023349.dkr.ecr.eu-west-1.amazonaws.com/dsci-sagemaker-rgsmapping:serve-tag-v1.2"
    prediction_instance_type      = "${var.ml_instance_type}"
    initial_instance_count        = "${var.initial_instance_count}"
    endpoint_name                 = "${var.endpoint_name}"
    sagemaker_prediction_role_arn = "${var.sm_rgs_training_role}"
    model_data_url                = "s3://${var.dsci_rgs_mapping_bucket}/rgsmapping-50k-200-word/output/model.tar.gz"
    autoscaling_min_value         = "${var.autoscaling_min_value}"
    autoscaling_max_value         = "${var.autoscaling_max_value}"
    autoscaling_role_arn          = "${var.autoscaling_role_arn}"
    is_autoscaling_enabled        = "${var.is_autoscaling_enabled}"
  }
}

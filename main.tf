module "rgs-classification-cloudwatch-event-rule" {
  source                         = "./cloudwatch-event-rules/rgs-classification-training"
  start_training_event_rule_name = "${local.dsci_start_training_event_rule_name}"
  name_prefix                    = "${local.name_prefix}"
  step_function_name             = "${local.dsci_rgs_mapping_state_machine_name}"
  sm_rgs_training_role           = "${aws_iam_role.rgs_classfication_training.arn}"
  accountid                      = "${var.accountid}"
  endpoint_name                  = "${local.dsci_endpoint_name}"
  dsci_rgs_mapping_bucket        = "${local.dsci_rgs_mapping_bucket_name}"
  step_function_arn              = "${aws_sfn_state_machine.dsci_rgs_mapping_state_machine.id}"
  training_event_rule_enabled    = "${var.training_event_rule_enabled}"
  initial_instance_count         = "${var.initial_instance_count}"
  ml_instance_type               = "${var.ml_instance_type}"
  autoscaling_role_arn           = "${data.terraform_remote_state.base_config.lambda_app_sagemaker_apply_auto_scaling_role_arn}"
  is_autoscaling_enabled         = "${var.is_autoscaling_enabled}"

  tags = "${var.default_tags}"
}

module "step-function-training-failure-event-rule" {
  source                 = "./cloudwatch-event-rules/step-function-failure"
  step_function_name     = "${local.dsci_rgs_mapping_state_machine_name}"
  step_function_arn      = "${aws_sfn_state_machine.dsci_rgs_mapping_state_machine.id}"
  notification_topic_arn = "${data.terraform_remote_state.base_config.dsci_notifications_sns_topic_arn}"

  tags = "${var.default_tags}"
}

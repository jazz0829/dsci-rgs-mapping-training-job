locals {
  name_prefix                                     = "${terraform.workspace}"
  dsci_rgs_mapping_state_machine_name             = "${local.name_prefix}-${var.step_function_name}"
  dsci_rgs_mapping_bucket_name                    = "${local.name_prefix}-dsci-rgs-mapping-${var.accountid}-${var.region}"
  dsci_start_training_event_rule_name             = "${local.name_prefix}-dsci-cw-rule-rgs-classification-training"
  dsci_sagemaker_rgs_classification_training_role = "${local.name_prefix}-dsci-sagemaker-rgs-classification-training-role"
  dsci_invoke_sagemaker_endpoint_role             = "${local.name_prefix}-dsci-invoke-sagemaker-endpoint-role"
  dsci_invoke_sagemaker_endpoint_role_policy      = "${local.name_prefix}-dsci-invoke-sagemaker-endpoint-role-policy"
  dsci_dsci_rgs_trained_model_allow_write         = "${local.name_prefix}-dsci-rgs-trained-model-allow-write"
  dsci_sagemaker_rgsmapping_invoker_for_eol       = "${local.name_prefix}-dsci-sagemaker-rgsmapping-invoker-for-eol"
  dsci_rgsmapping_endpoint_invoke_policy          = "${local.name_prefix}-dsci-rgsmapping-endpoint-invoke-policy"
  dsci_endpoint_name                              = "${local.name_prefix}-${var.endpoint_name}"
}

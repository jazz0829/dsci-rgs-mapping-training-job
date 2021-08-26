variable "start_training_event_rule_name" {}

variable "start_training_schedule" {
  default = "cron(0 2 1 * ? *)"
}

variable "start_training_event_rule_description" {
  default = "Cloudwatch event rule to schedule training of the RGS classification prediction model"
}

variable "start_training_event_target_id" {
  default = "TrainingRgsModel"
}

variable "start_training_event_input_file" {
  default = "cloudwatch-event-rules/rgs-classification-training/input.json"
}

variable "start_training_role_name" {
  default = "dsci-cw-rgs-classification-allow-start-execution"
}

variable "tags" {
  type = "map"
}

variable "name_prefix" {}
variable "step_function_name" {}
variable "step_function_arn" {}
variable "sm_rgs_training_role" {}
variable "accountid" {}
variable "endpoint_name" {}
variable "dsci_rgs_mapping_bucket" {}
variable "training_event_rule_enabled" {}
variable "initial_instance_count" {}
variable "ml_instance_type" {}

variable "autoscaling_min_value" {
  default = 2
}

variable "autoscaling_max_value" {
  default = 4
}

variable "autoscaling_role_arn" {}
variable "is_autoscaling_enabled" {}

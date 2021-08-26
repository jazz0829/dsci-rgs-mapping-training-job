variable "project" {
  default = "rgs-mapping"
}

variable "default_period" {
  default = "60"
}

variable "endpoint_name" {
  default = "dsci-rgs-mapping-endpoint"
}

variable "ecr_repo_name" {
  default = "dsci-sagemaker-rgsmapping"
}

variable "step_function_name" {
  default = "dsci-rgs-classification-step-function"
}

variable "step_function_definition_file" {
  default = "step-function.json"
}

variable "default_tags" {
  description = "Map of tags to add to all resources"
  type        = "map"

  default = {
    Terraform   = "true"
    GitHub-Repo = "exactsoftware/dsci-rgs-mapping-training-job"
  }
}

variable "dsci_trusted_aws_account1_number" {
  default = "830160409677"
}

variable "dsci_trusted_aws_account2_number" {
  default = "987270341901"
}

variable "region" {}
variable "accountid" {}
variable "training_event_rule_enabled" {}
variable "initial_instance_count" {}
variable "ml_instance_type" {}
variable "is_autoscaling_enabled" {}

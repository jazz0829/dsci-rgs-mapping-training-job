output "secret_in_user" {
  value = "${aws_iam_access_key.in_invoker_key.secret}"
}

output "accesskey_in_user" {
  value = "${aws_iam_access_key.in_invoker_key.id}"
}

output "dsci_rgs_mapping_state_machine" {
  value = "${aws_sfn_state_machine.dsci_rgs_mapping_state_machine.name}"
}

output "dsci_rgs_mapping_bucket" {
  value = "${aws_s3_bucket.dsci_rgs_mapping_bucket.id}"
}

output "invoke_sagemaker_endpoint_role_arn" {
  value = "${aws_iam_role.invoke_sagemaker_endpoint_role.arn}"
}

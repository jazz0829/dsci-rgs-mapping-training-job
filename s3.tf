resource "aws_s3_bucket" "dsci_rgs_mapping_bucket" {
  bucket = "${local.dsci_rgs_mapping_bucket_name}"
  acl    = "private"
  tags   = "${var.default_tags}"
}

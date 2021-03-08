# This should be a 0 or 1 indicating whether to being up a bastion host
# to test that the connectivity works from ec2 to the public internet or
# various connectivity tests within the vpc
variable "bastion" {}

variable "tag_prefix" {
  type = "string"
}

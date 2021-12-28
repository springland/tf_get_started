resource "random_integer" "rand" {
  min = 10000
  max = 99999
}


locals {

  naming_perfix = "${var.naming_prefix}-dev"
 
  s3_bucket_name = lower("${local.naming_perfix}-${random_integer.rand.result}")
  common_tags = {

    company = "${var.company}"
    env     = "${var.env}"
    billing = "06905"
    project = "${var.company}_TerraformGetStarted"



  }


}



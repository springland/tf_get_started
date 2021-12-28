resource "random_integer" "rand" {
  min = 10000
  max = 99999
}


locals {
  s3_bucket_name = "springland-tf-${random_integer.rand.result}"
  common_tags = {

    company = "${var.company}"
    env     = "${var.env}"
    billing = "06905"
    project = "${var.company}_TerraformGetStarted"



  }


}



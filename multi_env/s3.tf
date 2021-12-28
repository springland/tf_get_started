

module "s3_module" {
  source                      = "./s3_module"
  s3_bucket_name              = local.s3_bucket_name
  aws_elb_service_account_arn = data.aws_elb_service_account.root.arn

}
resource "aws_s3_bucket_object" "web-content" {
  for_each = {
    index1 = "/website/index1.html"
    index2 = "/website/index2.html"
    image1 = "/website/image1.png"
    image2 = "/website/image2.png"
  }
  bucket = module.s3_module.s3_bucket.id
  key    = each.value
  source = ".${each.value}"

}



resource "aws_s3_bucket" "s3_bucket" {
  bucket        = local.s3_bucket_name
  acl           = "private"
  force_destroy = true

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "${data.aws_elb_service_account.root.arn}"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${local.s3_bucket_name}/alb-logs/*"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${local.s3_bucket_name}/alb-logs/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "arn:aws:s3:::${local.s3_bucket_name}"
    }
  ]
}
    POLICY
}


resource "aws_s3_bucket_object" "indexfile1" {
  bucket = aws_s3_bucket.s3_bucket.bucket
  key    = "/website/index1.html"
  source = "./website/index1.html"

}

resource "aws_s3_bucket_object" "indexfile2" {
  bucket = aws_s3_bucket.s3_bucket.bucket
  key    = "/website/index2.html"
  source = "./website/index2.html"

}

resource "aws_s3_bucket_object" "pngfile1" {
  bucket = aws_s3_bucket.s3_bucket.bucket
  key    = "/website/image1.png"
  source = "./website/image1.png"

}

resource "aws_s3_bucket_object" "pngfile2" {
  bucket = aws_s3_bucket.s3_bucket.bucket
  key    = "/website/image2.png"
  source = "./website/image2.png"

}
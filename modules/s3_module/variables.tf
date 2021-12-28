variable "s3_bucket_name" {
    type = string
    description = "s3 bucket name to be created"
    default = ""
}

variable "aws_elb_service_account_arn" {
    type = string
    default = ""
}
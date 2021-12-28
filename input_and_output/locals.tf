locals {
    common_tags = {
        
        company = "${var.company}"
        env = "${var.env}"
        billing = "06905"
        project = "${var.company}_TerraformGetStarted"
    }
}
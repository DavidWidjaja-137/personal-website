
terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket         = "terraform-state.david-pw.com"
    key            = "production/services/elastic-beanstalk/personal-website/terraform.tfstate"
    region         = "us-west-2"
  }
}

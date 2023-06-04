locals {

    service_name = "elastic-beanstalk-personal-website"
    aws_service_name = "elastic-beanstalk"
    template_name = "personal-website-config-template"
    environment_name = "personal-website-environment-2"
    application_name = "personal-website"
}

terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "5.1.0"
    }
  }
}

provider "aws" {

    region = "us-west-2"
    
    default_tags {
        tags = {
            service_name = local.service_name
        }
    }
}

resource "aws_s3_bucket" "application_versions" {
    bucket = "elastic-beanstalk-application-versions.david-pw.com"
}


resource "aws_s3_object" "application_version" {
    bucket = aws_s3_bucket.application_versions.bucket
    key = "${local.aws_service_name}/${local.application_name}/app.zip"
    source = "${path.module}/app.zip"

    etag = filemd5("${path.module}/app.zip")
}

resource "aws_elastic_beanstalk_application" "this" {
    name = local.application_name
    description = "personal website application on elastic beanstalk"
}

resource "aws_elastic_beanstalk_application_version" "this" {
    name = "personal-website-app-${aws_s3_object.application_version.etag}"
    description = "personal website application version on elastic beanstalk"

    application = aws_elastic_beanstalk_application.this.name

    bucket = aws_s3_bucket.application_versions.id
    key = aws_s3_object.application_version.id
}

resource "aws_elastic_beanstalk_configuration_template" "this" {
    name = local.template_name
    description = "personal website application configuration template on elastic beanstalk"

    application = aws_elastic_beanstalk_application.this.name

    solution_stack_name = "64bit Amazon Linux 2023 v4.0.1 running Python 3.11"
}

resource "aws_elastic_beanstalk_environment" "this" {
    name = local.environment_name
    description = "personal website environment on elastic beanstalk"

    application = aws_elastic_beanstalk_application.this.name

    tier = "WebServer"
    template_name = aws_elastic_beanstalk_configuration_template.this.name

    # define instance profile for ec2 instances
    setting {
        namespace = "aws:autoscaling:launchconfiguration"
        name = "IamInstanceProfile"
        value = aws_iam_instance_profile.eb_ec2_instance_profile.name
    }

    setting {
        namespace = "aws:ec2:instances"
        name = "InstanceTypes"
        value = "t4g.small"
    }

    setting {
        namespace = "aws:elasticbeanstalk:application"
        name = "Application Healthcheck URL"
        value = "/"
    }

    setting {
        namespace = "aws:elasticbeanstalk:environment"
        name = "EnvironmentType"
        value = "SingleInstance"
    }

    setting {
        namespace = "aws:elasticbeanstalk:environment"
        name = "ServiceRole"
        value = aws_iam_role.eb_service_role.name
    }

}

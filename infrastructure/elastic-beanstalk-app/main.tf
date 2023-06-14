locals {

    service_name = "elastic-beanstalk-personal-website"
    aws_service_name = "elastic-beanstalk"
    template_name = "personal-website-config-template"
    environment_name = "personal-website-environment"
    application_name = "personal-website"
    s3_object_etag = filemd5("${path.module}/app.zip")
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
    key = "${local.aws_service_name}/${local.application_name}/app-${local.s3_object_etag}.zip"
    source = "${path.module}/app.zip"

    etag = local.s3_object_etag
}

resource "aws_elastic_beanstalk_application" "this" {
    name = local.application_name
    description = "personal website application on elastic beanstalk"
}

resource "aws_elastic_beanstalk_application_version" "this" {
    name = "personal-website-app-${local.s3_object_etag}"
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

    setting {
        namespace = "aws:autoscaling:asg"
        name = "MaxSize"
        value = 1
    }

    setting {
        namespace = "aws:autoscaling:launchconfiguration"
        name = "IamInstanceProfile"
        value = aws_iam_instance_profile.eb_ec2_instance_profile.name
    }

    setting {
        namespace = "aws:ec2:instances"
        name = "InstanceTypes"
        value = "t3.micro,t3.small"
    }

    setting {
        namespace = "aws:ec2:instances"
        name = "SupportedArchitectures"
        value = "x86_64"
    }

    # deploy on default public vpc
    setting {
        namespace = "aws:ec2:vpc"
        name = "VPCId"
        value = "vpc-bda982c5"
    }

    # deploy on 2 availability zones
    setting {
        namespace = "aws:ec2:vpc"
        name = "Subnets"
        value = "subnet-ef66e297,subnet-8e70d1c4"
    }

    setting {
        namespace = "aws:ec2:vpc"
        name = "ELBSubnets"
        value = "subnet-ef66e297,subnet-8e70d1c4"
    }

    setting {
        namespace = "aws:ec2:vpc"
        name = "AssociatePublicIpAddress"
        value = true
    }

    setting {
        namespace = "aws:elasticbeanstalk:application"
        name = "Application Healthcheck URL"
        value = "/"
    }

    setting {
        namespace = "aws:elasticbeanstalk:environment"
        name = "ServiceRole"
        value = aws_iam_role.eb_service_role.arn
    }

    setting {
        namespace = "aws:elasticbeanstalk:environment"
        name = "LoadbalancerType"
        value = "application"
    }

    setting {
        namespace = "aws:elasticbeanstalk:healthreporting:system"
        name = "SystemType"
        value = "enhanced"
    }

    # now do some ssl stuff
    ########################################

    # define a https listener on port 443 with a ssl certificate from acm
    setting {
        namespace = "aws:elbv2:listener:443"
        name = "Protocol"
        value = "HTTPS"
    }

    setting {
        namespace = "aws:elbv2:listener:443"
        name = "SSLCertificateArns"
        value = aws_acm_certificate_validation.this_cert_validation.certificate_arn
    }
    
}

resource "aws_acm_certificate" "this_cert" {
    domain_name = "www.david-pw.com"
    subject_alternative_names = []
    validation_method = "DNS"

    validation_option {
        domain_name = "www.david-pw.com"
        validation_domain = "david-pw.com"
    }
}

resource "aws_route53_record" "this_dns_records" {
  for_each = {
    for dvo in aws_acm_certificate.this_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 300
  type            = each.value.type
  zone_id         = "Z03275343K7VP4WLMLTBH"
}

resource "aws_acm_certificate_validation" "this_cert_validation" {
  certificate_arn         = aws_acm_certificate.this_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.this_dns_records : record.fqdn]
}


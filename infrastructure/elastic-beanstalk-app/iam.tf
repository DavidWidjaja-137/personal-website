
resource "aws_iam_role" "eb_service_role" {
    name = "elastic-beanstalk-service-role"
    description = "elastic-beanstalk assumes this role when running this application"

    assume_role_policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Principal": {
                    "Service": "elasticbeanstalk.amazonaws.com"
                },
                "Action": "sts:AssumeRole"
            }
        ]
    })

    managed_policy_arns = [
        "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth",
        "arn:aws:iam::aws:policy/AWSElasticBeanstalkManagedUpdatesCustomerRolePolicy"
    ]
}

resource "aws_iam_role" "eb_instance_profile_role" {
    name = "elastic-beanstalk-ec2-webserver-service-role"
    description = "ec2 instances under elastic beanstalk assume this role when running this application"

    assume_role_policy = jsonencode({
        "Version": "2008-10-17",
        "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
        ]
    })

    managed_policy_arns = [
        "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier",
        "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier",
        "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"
    ]
}

resource "aws_iam_instance_profile" "eb_ec2_instance_profile" {
    role = aws_iam_role.eb_instance_profile_role.name
}
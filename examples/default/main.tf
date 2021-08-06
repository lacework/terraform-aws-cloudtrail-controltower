# This example assumes that Lacework CLI has been set up.  
# Instructions for Lacework CLI setup - installation and configuration sections here: https://www.lacework.com/blog/running-with-lacework-cli/

# This example assumes that you have multiple AWS profiles in your ~/.aws/credentials file that map to your audit and log_archive AWS accounts

provider "aws" {
  alias  = "log_archive"
  # profile  = "<profile name for log_archive account in ~/.aws/credentials>"
  profile  = "287453222145_AWSAdministratorAccess"
  region = "us-east-1"
}

provider "aws" {
  alias  = "audit"
  # profile  = "<profile name for audit account in ~/.aws/credentials>"
  profile  = "918733600796_AWSAdministratorAccess"
  region = "us-east-1"
}

module "control_tower_integration_setup" {
  source = "../../"
  # source  = "./terraform-aws-cloudtrail-controltower"
  # version = "~> 0.1"
  providers = {
    aws.audit = aws.audit
    aws.log_archive = aws.log_archive
  }
  # SNS Topic ARN is usually in the form: arn:aws:sns:<control_tower_region>:<aws_audit_account_id>:aws-controltower-AllConfigNotifications
  sns_topic_arn   = "arn:aws:sns:<control_tower_region>:<aws_audit_account_id>:aws-controltower-AllConfigNotifications"
  # S3 Bucket ARN is usually in the form: arn:aws:s3:::aws-controltower-logs-<log_archive_account_id>-<control_tower_region>
  s3_bucket_arn = "arn:aws:s3:::aws-controltower-logs-<log_archive_account_id>-<control_tower_region>"
}

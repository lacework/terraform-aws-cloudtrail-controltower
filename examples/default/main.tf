provider "lacework" {
  organization = true
}

provider "aws" {
  alias  = "log_archive"
  profile  = "287453222145_AWSAdministratorAccess"
  region = "us-east-1"
}

provider "aws" {
  alias  = "audit"
  profile  = "918733600796_AWSAdministratorAccess"
  region = "us-east-1"
}

module "control_tower_integration_setup" {
  source = "../../"
  providers = {
    aws.audit = aws.audit
    aws.log_archive = aws.log_archive
  }
  
  sns_topic_arn   = "arn:aws:sns:us-east-1:918733600796:aws-controltower-AllConfigNotifications"
  
  s3_bucket_arn = "arn:aws:s3:::aws-controltower-logs-287453222145-us-east-1"
}

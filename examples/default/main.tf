# This example assumes that Lacework CLI has been set up.  
# Instructions for Lacework CLI setup - installation and configuration sections here: https://www.lacework.com/blog/running-with-lacework-cli/

# This example assumes that you have multiple AWS profiles in your ~/.aws/credentials file that map to your audit and log_archive AWS accounts

provider "aws" {
  alias  = "log_archive"
  profile  = "<profile name for log_archive account in ~/.aws/credentials>"
  # e.g. profile  = "287453222145_AWSAdministratorAccess"
  region = "us-east-1"
}

provider "aws" {
  alias  = "audit"
  profile  = "<profile name for audit account in ~/.aws/credentials>"
  # e.g. profile  = "918733600796_AWSAdministratorAccess"
  region = "us-east-1"
}

module "control_tower_integration_setup" {
  source  = "lacework/cloudtrail-controltower/aws"
  # source  = "./terraform-aws-cloudtrail-controltower"
  version = "~> 0.1"
  providers = {
    aws.audit = aws.audit
    aws.log_archive = aws.log_archive
  }
  control_tower_region       = "<aws region for landing zone, e.g. us-east-1>"
  aws_audit_account_id       = "<aws account id for audit account, e.g. 918733600796>"
  aws_log_archive_account_id = "<aws account id for audit account, e.g. 287453222145>"
  aws_organization_id        = "<aws org ID, e.g. o-e07mx5b8dw>"
}


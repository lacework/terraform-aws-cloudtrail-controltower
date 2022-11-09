terraform {
  required_version = ">= 0.15.1"

  required_providers {
    aws    = {
      source = "hashicorp/aws"
      version = ">= 3.0, < 5.0.0"
      configuration_aliases = [aws.audit, aws.log_archive]
    }
    random = ">= 2.1"
    time   = "~> 0.6"
    lacework = {
      source  = "lacework/lacework"
      version = "~> 1.0"
    }
  }
}

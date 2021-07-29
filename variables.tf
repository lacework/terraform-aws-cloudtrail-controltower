
variable "org_account_mappings" {
  type = list(object({
    default_lacework_account = string
    mapping = list(object({
      lacework_account = string
      aws_accounts     = list(string)
    }))
  }))
  default     = []
  description = "Mapping of AWS accounts to Lacework accounts within a Lacework organization"
}

variable "use_existing_iam_role" {
  type        = bool
  default     = false
  description = "Set this to true to use an existing IAM role"
}

variable "iam_role_name" {
  type        = string
  default     = ""
  description = "The IAM role name. Required to match with iam_role_arn if use_existing_iam_role is set to true"
}

variable "iam_role_arn" {
  type        = string
  default     = ""
  description = "The IAM role ARN is required when setting use_existing_iam_role to true"
}

variable "iam_role_external_id" {
  type        = string
  default     = ""
  description = "The external ID configured inside the IAM role is required when setting use_existing_iam_role to true"
}

variable "external_id_length" {
  type        = number
  default     = 16
  description = "The length of the external ID to generate. Max length is 1224. Ignored when use_existing_iam_role is set to true"
}

variable "prefix" {
  type        = string
  default     = "lacework-ct"
  description = "The prefix that will be use at the beginning of every generated resource"
}

variable "enable_log_file_validation" {
  type        = bool
  default     = false
  description = "Specifies whether cloudtrail log file integrity validation is enabled"
}

variable "log_bucket_name" {
  type        = string
  default     = ""
  description = "Name of the S3 bucket for access logs"
}

variable "sns_topic_arn" {
  type        = string
  default     = ""
  description = "The SNS topic ARN"
}

variable "sns_topic_name" {
  type        = string
  default     = "aws-controltower-AllConfigNotifications"
  description = "The SNS topic name"
}

variable "sqs_queue_name" {
  type        = string
  default     = ""
  description = "The SQS queue name"
}

variable "cross_account_policy_name" {
  type    = string
  default = ""
}

variable "sqs_queues" {
  type        = list(string)
  default     = []
  description = "List of SQS queues to configure in the Lacework cross-account policy"
}

variable "lacework_integration_name" {
  type        = string
  default     = "TF cloudtrail"
  description = "The name of the integration in Lacework."
}

variable "lacework_aws_account_id" {
  type        = string
  default     = "434813966438"
  description = "The Lacework AWS account that the IAM role will grant access"
}

variable "wait_time" {
  type        = string
  default     = "10s"
  description = "Amount of time to wait before the next resource is provisioned."
}

variable "tags" {
  type        = map(string)
  description = "A map/dictionary of Tags to be assigned to created resources"
  default     = {}
}

variable "aws_audit_account_id" {
  type = string
  description = "The AWS account set up by control tower to house the consolidated SNS topic. Usually called 'Audit' but can be named differently."
}

variable "aws_log_archive_account_id" {
  type = string
  description = "The AWS account set up by control tower to house the S3 bucket for consolidated CloudTrail logging. Usually called 'Log Archive' but can be named differently."
}

variable "aws_organization_id" {
  type = string
  description = "The identifier of the AWS organization.  Usually in the form 'o-xxxxxxxxxx'."
}

variable "control_tower_region" {
  type = string
  default = "us-east-1"
  description = "The landing zone region for Control Tower."
}

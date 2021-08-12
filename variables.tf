variable "sns_topic_arn" {
  type        = string
  description = "The SNS topic ARN. Usually in the form of: arn:aws:sns:<control-tower-region>:<aws_audit_account_id>:aws-controltower-AllConfigNotifications"
}

variable "s3_bucket_arn" {
  type = string
  description = "The ARN for the  S3 bucket for consolidated CloudTrail logging. Usually in the form like: arn:aws:s3:::aws-controltower-logs-<log_archive_account_id>-<control_tower_region>"
}

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
  description = "Set this to true to use an existing IAM role from the log_archive AWS Account"
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

variable "sqs_queue_name" {
  type        = string
  default     = ""
  description = "The SQS queue name"
}

variable "cross_account_policy_name" {
  type    = string
  default = ""
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

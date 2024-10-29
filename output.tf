output "sqs_name" {
  value       = local.sqs_queue_name
  description = "SQS Queue name"
}

output "sqs_arn" {
  value       = aws_sqs_queue.lacework_cloudtrail_sqs_queue.arn
  description = "SQS Queue ARN"
}

output "sqs_url" {
  value       = aws_sqs_queue.lacework_cloudtrail_sqs_queue.id
  description = "SQS Queue URL"
}

output "sns_arn" {
  value       = var.sns_topic_arn
  description = "SNS Topic ARN"
}

output "external_id" {
  value       = local.iam_role_external_id
  description = "The External ID configured into the IAM role"
}

output "iam_role_name" {
  value       = var.iam_role_name
  description = "The IAM Role name"
}

output "iam_role_arn" {
  value       = local.iam_role_arn
  description = "The IAM Role ARN"
}

output "lacework_integration_guid" {
  value       = local.lacework_integration_guid
  description = "Lacework CloudTrail Integration GUID"
}

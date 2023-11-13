locals {
  sqs_queue_name   = length(var.sqs_queue_name) > 0 ? var.sqs_queue_name : "${var.prefix}-sqs-${random_id.uniq.hex}"
  s3_logs_location = "${var.s3_bucket_arn}/${data.aws_organizations_organization.main.id}/*AWSLogs/*"
  cross_account_policy_name = (
    length(var.cross_account_policy_name) > 0 ? var.cross_account_policy_name : "${var.prefix}-cross-acct-policy-${random_id.uniq.hex}"
  )
  iam_role_arn         = module.lacework_ct_iam_role.created ? module.lacework_ct_iam_role.arn : var.iam_role_arn
  iam_role_external_id = module.lacework_ct_iam_role.created ? module.lacework_ct_iam_role.external_id : var.iam_role_external_id
  iam_role_name = var.use_existing_iam_role ? var.iam_role_name : (
    length(var.iam_role_name) > 0 ? var.iam_role_name : "${var.prefix}-iam-${random_id.uniq.hex}"
  )
}

data "aws_organizations_organization" "main" {
  provider = aws.audit
}

resource "random_id" "uniq" {
  byte_length = 4
}

resource "aws_sqs_queue" "lacework_cloudtrail_sqs_queue" {
  provider = aws.audit
  name     = local.sqs_queue_name
  tags     = var.tags
}

resource "aws_sqs_queue_policy" "lacework_sqs_queue_policy" {
  provider   = aws.audit
  depends_on = [time_sleep.wait_time]
  queue_url  = aws_sqs_queue.lacework_cloudtrail_sqs_queue.id
  policy     = <<POLICY
{
	"Version": "2012-10-17",
	"Id": "lacework_sqs_policy_${random_id.uniq.hex}",
	"Statement": [
		{
			"Sid": "AllowLaceworkSNSTopicToSendMessage",
			"Effect": "Allow",
			"Principal": {
				"AWS": "*"
			},
			"Action": "SQS:SendMessage",
			"Resource": "${aws_sqs_queue.lacework_cloudtrail_sqs_queue.arn}",
			"Condition": {
				"ArnEquals": {
					"aws:SourceArn": "${var.sns_topic_arn}"
				}
			}
		},
		{
			"Sid": "AllowLaceworkCrossAccountRoleToAccessSQSQueue",
			"Effect": "Allow",
			"Principal": {
				"AWS": "${local.iam_role_arn}"
			},
			"Action": [
				"sqs:DeleteMessage",
				"sqs:ReceiveMessage",
				"sqs:GetQueueAttributes"
			      ],
			"Resource": "${aws_sqs_queue.lacework_cloudtrail_sqs_queue.arn}"
		}
	]
}
POLICY
}

resource "aws_sns_topic_subscription" "lacework_sns_topic_sub" {
  provider  = aws.audit
  topic_arn = var.sns_topic_arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.lacework_cloudtrail_sqs_queue.arn
}

data "aws_iam_policy_document" "read_logs" {
  provider = aws.log_archive
  version  = "2012-10-17"

  statement {
    sid       = "ReadLogFiles"
    actions   = ["s3:Get*"]
    resources = ["${local.s3_logs_location}"]
  }

  statement {
    sid       = "GetAccountAlias"
    actions   = ["iam:ListAccountAliases"]
    resources = ["*"]
  }

  statement {
    sid       = "ListLogFiles"
    resources = ["${local.s3_logs_location}"]
    actions   = ["s3:ListBucket"]

    condition {
      test     = "StringLike"
      variable = "s3:prefix"
      values   = ["*AWSLogs/"]
    }
  }

  statement {
    sid       = "ConsumeNotifications"
    resources = ["${aws_sqs_queue.lacework_cloudtrail_sqs_queue.arn}"]
    actions = [
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "sqs:DeleteMessage",
      "sqs:ReceiveMessage"
    ]
  }

  statement {
    sid       = "Debug"
    resources = ["*"]
    actions = [
      "cloudtrail:DescribeTrails",
      "cloudtrail:GetTrail",
      "cloudtrail:GetTrailStatus",
      "cloudtrail:ListPublicKeys",
      "s3:GetBucketAcl",
      "s3:GetBucketPolicy",
      "s3:ListAllMyBuckets",
      "s3:GetBucketLocation",
      "s3:GetBucketLogging",
      "sns:GetSubscriptionAttributes",
      "sns:GetTopicAttributes",
      "sns:ListSubscriptions",
      "sns:ListSubscriptionsByTopic",
      "sns:ListTopics"
    ]
  }
}

data "aws_iam_policy_document" "kms_decrypt" {
  provider = aws.log_archive
  version  = "2012-10-17"

  statement {
    sid       = "DecryptLogFiles"
    actions   = ["kms:Decrypt"]
    resources = [var.kms_key_arn]
  }
}

data "aws_iam_policy_document" "cross_account_policy" {
  provider = aws.log_archive
  version  = "2012-10-17"
  source_policy_documents = var.kms_key_arn == "" ? [
    data.aws_iam_policy_document.read_logs.json,
  ]:[
    data.aws_iam_policy_document.read_logs.json,
    data.aws_iam_policy_document.kms_decrypt.json
  ]
}

resource "aws_iam_policy" "cross_account_policy" {
  provider    = aws.log_archive
  name        = local.cross_account_policy_name
  description = "A cross account policy to allow Lacework to pull config and cloudtrail"
  policy      = data.aws_iam_policy_document.cross_account_policy.json
}

module "lacework_ct_iam_role" {
  providers = {
    aws = aws.log_archive
  }
  #  source                  = "lacework/iam-role/aws" 
  #  version                 = "~> 0.4"
  source                  = "git::https://github.com/lacework/terraform-aws-iam-role.git?ref=tmacdonald/grow-2447/use-external-IAM-role"
  create                  = var.use_existing_iam_role ? false : true
  iam_role_name           = local.iam_role_name
  lacework_aws_account_id = var.lacework_aws_account_id
  tags                    = var.tags
}

resource "aws_iam_role_policy_attachment" "lacework_cross_account_iam_role_policy" {
  provider   = aws.log_archive
  role       = local.iam_role_name
  policy_arn = aws_iam_policy.cross_account_policy.arn
  depends_on = [module.lacework_ct_iam_role]
}

# wait for X seconds for things to settle down in the AWS side
# before trying to create the Lacework external integration
resource "time_sleep" "wait_time" {
  create_duration = var.wait_time
  depends_on = [
    aws_iam_role_policy_attachment.lacework_cross_account_iam_role_policy,
    aws_sns_topic_subscription.lacework_sns_topic_sub
  ]
}

resource "lacework_integration_aws_ct" "default" {
  name      = var.lacework_integration_name
  queue_url = aws_sqs_queue.lacework_cloudtrail_sqs_queue.id
  credentials {
    role_arn    = local.iam_role_arn
    external_id = local.iam_role_external_id
  }

  dynamic "org_account_mappings" {
    for_each = var.org_account_mappings
    content {
      default_lacework_account = org_account_mappings.value["default_lacework_account"]

      dynamic "mapping" {
        for_each = org_account_mappings.value["mapping"]
        content {
          lacework_account = mapping.value["lacework_account"]
          aws_accounts     = mapping.value["aws_accounts"]
        }
      }
    }
  }

  depends_on = [time_sleep.wait_time]
}

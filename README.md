<a href="https://lacework.com"><img src="https://techally-content.s3-us-west-1.amazonaws.com/public-content/lacework_logo_full.png" width="600"></a>

# terraform-aws-cloudtrail-controltower

[![GitHub release](https://img.shields.io/github/release/lacework/terraform-aws-cloudtrail-controltower.svg)](https://github.com/lacework/terraform-aws-cloudtrail-controltower/releases/)
[![Codefresh build status]( https://g.codefresh.io/api/badges/pipeline/lacework/terraform-modules%2Ftest-compatibility?type=cf-1&key=eyJhbGciOiJIUzI1NiJ9.NWVmNTAxOGU4Y2FjOGQzYTkxYjg3ZDEx.RJ3DEzWmBXrJX7m38iExJ_ntGv4_Ip8VTa-an8gBwBo)]( https://g.codefresh.io/pipelines/edit/new/builds?id=607e25e6728f5a6fba30431b&pipeline=test-compatibility&projects=terraform-modules&projectId=607db54b728f5a5f8930405d)

A Terraform Module for configuring an integration with Lacework and AWS for CloudTrail analysis for organizations using AWS Control Tower.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.15.1 |
| aws | ~> 3.0 |
| lacework | ~> 0.2 |
| random | >= 2.1 |
| time | ~> 0.6 |

## Providers

| Name | Version |
|------|---------|
| aws.audit | ~> 3.0 |
| aws.log\_archive | ~> 3.0 |
| lacework | ~> 0.2 |
| random | >= 2.1 |
| time | ~> 0.6 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| lacework\_ct\_iam\_role | lacework/iam-role/aws | ~> 0.1 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.cross_account_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy_attachment.lacework_cross_account_iam_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_sns_topic_subscription.lacework_sns_topic_sub](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_sqs_queue.lacework_cloudtrail_sqs_queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue_policy.lacework_sqs_queue_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_policy) | resource |
| [lacework_integration_aws_ct.default](https://registry.terraform.io/providers/lacework/lacework/latest/docs/resources/integration_aws_ct) | resource |
| [random_id.uniq](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [time_sleep.wait_time](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [aws_iam_policy_document.cross_account_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| s3\_bucket\_arn | The ARN for the  S3 bucket for consolidated CloudTrail logging. Usually in the form like: arn:aws:s3:::aws-controltower-logs-<log\_archive\_account\_id>-<control\_tower\_region> | `string` | n/a | yes |
| sns\_topic\_arn | The SNS topic ARN. Usually in the form of: arn:aws:sns:<control-tower-region>:<aws\_audit\_account\_id>:aws-controltower-AllConfigNotifications | `string` | n/a | yes |
| cross\_account\_policy\_name | n/a | `string` | `""` | no |
| enable\_log\_file\_validation | Specifies whether cloudtrail log file integrity validation is enabled | `bool` | `false` | no |
| external\_id\_length | The length of the external ID to generate. Max length is 1224. Ignored when use\_existing\_iam\_role is set to true | `number` | `16` | no |
| iam\_role\_arn | The IAM role ARN is required when setting use\_existing\_iam\_role to true | `string` | `""` | no |
| iam\_role\_external\_id | The external ID configured inside the IAM role is required when setting use\_existing\_iam\_role to true | `string` | `""` | no |
| iam\_role\_name | The IAM role name. Required to match with iam\_role\_arn if use\_existing\_iam\_role is set to true | `string` | `""` | no |
| lacework\_aws\_account\_id | The Lacework AWS account that the IAM role will grant access | `string` | `"434813966438"` | no |
| lacework\_integration\_name | The name of the integration in Lacework. | `string` | `"TF cloudtrail"` | no |
| org\_account\_mappings | Mapping of AWS accounts to Lacework accounts within a Lacework organization | <pre>list(object({<br>    default_lacework_account = string<br>    mapping = list(object({<br>      lacework_account = string<br>      aws_accounts     = list(string)<br>    }))<br>  }))</pre> | `[]` | no |
| prefix | The prefix that will be use at the beginning of every generated resource | `string` | `"lacework-ct"` | no |
| sqs\_queue\_name | The SQS queue name | `string` | `""` | no |
| tags | A map/dictionary of Tags to be assigned to created resources | `map(string)` | `{}` | no |
| use\_existing\_iam\_role | Set this to true to use an existing IAM role | `bool` | `false` | no |
| wait\_time | Amount of time to wait before the next resource is provisioned. | `string` | `"10s"` | no |
| kms\_key\_arn | Control Tower KMS key arn | `string` | `""` | no |


## Outputs

| Name | Description |
|------|-------------|
| external\_id | The External ID configured into the IAM role |
| iam\_role\_arn | The IAM Role ARN |
| iam\_role\_name | The IAM Role name |
| sns\_arn | SNS Topic ARN |
| sqs\_arn | SQS Queue ARN |
| sqs\_name | SQS Queue name |
| sqs\_url | SQS Queue URL |

<a href="https://lacework.com"><img src="https://techally-content.s3-us-west-1.amazonaws.com/public-content/lacework_logo_full.png" width="600"></a>

# terraform-aws-cloudtrail-controltower

[![GitHub release](https://img.shields.io/github/release/lacework/terraform-aws-cloudtrail-controltower.svg)](https://github.com/lacework/terraform-aws-cloudtrail-controltower/releases/)
[![Codefresh build status]( https://g.codefresh.io/api/badges/pipeline/lacework/terraform-modules%2Ftest-compatibility?type=cf-1&key=eyJhbGciOiJIUzI1NiJ9.NWVmNTAxOGU4Y2FjOGQzYTkxYjg3ZDEx.RJ3DEzWmBXrJX7m38iExJ_ntGv4_Ip8VTa-an8gBwBo)]( https://g.codefresh.io/pipelines/edit/new/builds?id=607e25e6728f5a6fba30431b&pipeline=test-compatibility&projects=terraform-modules&projectId=607db54b728f5a5f8930405d)

A Terraform Module for configuring an integration with Lacework and AWS for CloudTrail analysis for organizations using AWS Control Tower.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.0 |
| <a name="requirement_lacework"></a> [lacework](#requirement\_lacework) | ~> 2.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2.1 |
| <a name="requirement_time"></a> [time](#requirement\_time) | ~> 0.6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws.audit"></a> [aws.audit](#provider\_aws.audit) | >= 3.0 |
| <a name="provider_aws.log_archive"></a> [aws.log\_archive](#provider\_aws.log\_archive) | >= 3.0 |
| <a name="provider_lacework"></a> [lacework](#provider\_lacework) | ~> 2.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 2.1 |
| <a name="provider_time"></a> [time](#provider\_time) | ~> 0.6 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_lacework_ct_iam_role"></a> [lacework\_ct\_iam\_role](#module\_lacework\_ct\_iam\_role) | lacework/iam-role/aws | ~> 0.4 |

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
| [aws_iam_policy_document.kms_decrypt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.read_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_organizations_organization.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organization) | data source |
| [lacework_metric_module.lwmetrics](https://registry.terraform.io/providers/lacework/lacework/latest/docs/data-sources/metric_module) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cross_account_policy_name"></a> [cross\_account\_policy\_name](#input\_cross\_account\_policy\_name) | n/a | `string` | `""` | no |
| <a name="input_enable_log_file_validation"></a> [enable\_log\_file\_validation](#input\_enable\_log\_file\_validation) | Specifies whether cloudtrail log file integrity validation is enabled | `bool` | `false` | no |
| <a name="input_external_id_length"></a> [external\_id\_length](#input\_external\_id\_length) | **Deprecated** - Will be removed on our next major release v1.0.0 | `number` | `16` | no |
| <a name="input_iam_role_arn"></a> [iam\_role\_arn](#input\_iam\_role\_arn) | The IAM role ARN is required when setting use\_existing\_iam\_role to true | `string` | `""` | no |
| <a name="input_iam_role_external_id"></a> [iam\_role\_external\_id](#input\_iam\_role\_external\_id) | The external ID configured inside the IAM role is required when setting use\_existing\_iam\_role to true | `string` | `""` | no |
| <a name="input_iam_role_name"></a> [iam\_role\_name](#input\_iam\_role\_name) | The IAM role name. Required to match with iam\_role\_arn if use\_existing\_iam\_role is set to true | `string` | `""` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The KMS key arn, if Control Tower was deployed with custom KMS key | `string` | `""` | no |
| <a name="input_lacework_aws_account_id"></a> [lacework\_aws\_account\_id](#input\_lacework\_aws\_account\_id) | The Lacework AWS account that the IAM role will grant access | `string` | `"434813966438"` | no |
| <a name="input_lacework_integration_name"></a> [lacework\_integration\_name](#input\_lacework\_integration\_name) | The name of the integration in Lacework. | `string` | `"TF cloudtrail"` | no |
| <a name="input_org_account_mappings"></a> [org\_account\_mappings](#input\_org\_account\_mappings) | Mapping of AWS accounts to Lacework accounts within a Lacework organization | <pre>list(object({<br>    default_lacework_account = string<br>    mapping = list(object({<br>      lacework_account = string<br>      aws_accounts     = list(string)<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | The prefix that will be use at the beginning of every generated resource | `string` | `"lacework-ct"` | no |
| <a name="input_s3_bucket_arn"></a> [s3\_bucket\_arn](#input\_s3\_bucket\_arn) | The ARN for the  S3 bucket for consolidated CloudTrail logging. Usually in the form like: arn:aws:s3:::aws-controltower-logs-<log\_archive\_account\_id>-<control\_tower\_region> | `string` | n/a | yes |
| <a name="input_sns_topic_arn"></a> [sns\_topic\_arn](#input\_sns\_topic\_arn) | The SNS topic ARN. Usually in the form of: arn:aws:sns:<control-tower-region>:<aws\_audit\_account\_id>:aws-controltower-AllConfigNotifications | `string` | n/a | yes |
| <a name="input_sqs_queue_name"></a> [sqs\_queue\_name](#input\_sqs\_queue\_name) | The SQS queue name | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map/dictionary of Tags to be assigned to created resources | `map(string)` | `{}` | no |
| <a name="input_use_existing_iam_role"></a> [use\_existing\_iam\_role](#input\_use\_existing\_iam\_role) | Set this to true to use an existing IAM role from the log\_archive AWS Account | `bool` | `false` | no |
| <a name="input_wait_time"></a> [wait\_time](#input\_wait\_time) | Amount of time to wait before the next resource is provisioned. | `string` | `"10s"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_external_id"></a> [external\_id](#output\_external\_id) | The External ID configured into the IAM role |
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | The IAM Role ARN |
| <a name="output_iam_role_name"></a> [iam\_role\_name](#output\_iam\_role\_name) | The IAM Role name |
| <a name="output_lacework_integration_guid"></a> [lacework\_integration\_guid](#output\_lacework\_integration\_guid) | Lacework CloudTrail Integration GUID |
| <a name="output_sns_arn"></a> [sns\_arn](#output\_sns\_arn) | SNS Topic ARN |
| <a name="output_sqs_arn"></a> [sqs\_arn](#output\_sqs\_arn) | SQS Queue ARN |
| <a name="output_sqs_name"></a> [sqs\_name](#output\_sqs\_name) | SQS Queue name |
| <a name="output_sqs_url"></a> [sqs\_url](#output\_sqs\_url) | SQS Queue URL |
<!-- END_TF_DOCS -->
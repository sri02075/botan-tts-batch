data "aws_iam_role" "ecs_task_excution_role" {
  name = "${local.name}-ecs-excution-role"
}

// FIXME: 각 서비스에 맞는 역할로 분리가 필요
data "aws_iam_role" "ecs_task_role" {
  for_each = var.service_configs_v2
  name = "${local.name}-all-service-role"
}

# resource "aws_iam_role" "ecs_service" {
#   name = "ecs-service"

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Principal": {
#         "Service": "ecs-tasks.amazonaws.com"
#       },
#       "Effect": "Allow"
#     }
#   ]
# }
# EOF
# }

# data "aws_iam_policy_document" "ecs_service_elb" {
#   statement {
#     effect = "Allow"

#     actions = [
#       "ec2:Describe*"
#     ]

#     resources = [
#       "*"
#     ]
#   }

#   statement {
#     effect = "Allow"

#     actions = [
#       "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
#       "elasticloadbalancing:DeregisterTargets",
#       "elasticloadbalancing:Describe*",
#       "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
#       "elasticloadbalancing:RegisterTargets"
#     ]

#     resources = [
#       var.elb.arn
#     ]
#   }
# }

# data "aws_iam_policy_document" "ecs_service_standard" {

#   statement {
#     effect = "Allow"

#     actions = [
#       "ec2:DescribeTags",
#       "ecs:DeregisterContainerInstance",
#       "ecs:DiscoverPollEndpoint",
#       "ecs:Poll",
#       "ecs:RegisterContainerInstance",
#       "ecs:StartTelemetrySession",
#       "ecs:UpdateContainerInstancesState",
#       "ecs:Submit*",
#       "logs:CreateLogGroup",
#       "logs:CreateLogStream",
#       "logs:PutLogEvents"
#     ]

#     resources = [
#       "*"
#     ]
#   }
# }

# data "aws_iam_policy_document" "ecs_service_scaling" {

#   statement {
#     effect = "Allow"

#     actions = [
#       "application-autoscaling:*",
#       "ecs:DescribeServices",
#       "ecs:UpdateService",
#       "cloudwatch:DescribeAlarms",
#       "cloudwatch:PutMetricAlarm",
#       "cloudwatch:DeleteAlarms",
#       "cloudwatch:DescribeAlarmHistory",
#       "cloudwatch:DescribeAlarms",
#       "cloudwatch:DescribeAlarmsForMetric",
#       "cloudwatch:GetMetricStatistics",
#       "cloudwatch:ListMetrics",
#       "cloudwatch:PutMetricAlarm",
#       "cloudwatch:DisableAlarmActions",
#       "cloudwatch:EnableAlarmActions",
#       "iam:CreateServiceLinkedRole",
#       "sns:CreateTopic",
#       "sns:Subscribe",
#       "sns:Get*",
#       "sns:List*"
#     ]

#     resources = [
#       "*"
#     ]
#   }
# }

# resource "aws_iam_policy" "ecs_service_elb" {
#   name = "dev-to-elb"
#   path = "/"
#   description = "Allow access to the service elb"

#   policy = data.aws_iam_policy_document.ecs_service_elb.json
# }

# resource "aws_iam_policy" "ecs_service_standard" {
#   name = "dev-to-standard"
#   path = "/"
#   description = "Allow standard ecs actions"

#   policy = data.aws_iam_policy_document.ecs_service_standard.json
# }

# resource "aws_iam_policy" "ecs_service_scaling" {
#   name = "dev-to-scaling"
#   path = "/"
#   description = "Allow ecs service scaling"

#   policy = data.aws_iam_policy_document.ecs_service_scaling.json
# }

# resource "aws_iam_role_policy_attachment" "ecs_service_elb" {
#   role = aws_iam_role.ecs_service.name
#   policy_arn = aws_iam_policy.ecs_service_elb.arn
# }

# resource "aws_iam_role_policy_attachment" "ecs_service_standard" {
#   role = aws_iam_role.ecs_service.name
#   policy_arn = aws_iam_policy.ecs_service_standard.arn
# }

# resource "aws_iam_role_policy_attachment" "ecs_service_scaling" {
#   role = aws_iam_role.ecs_service.name
#   policy_arn = aws_iam_policy.ecs_service_scaling.arn
# }


// FIXME: 역할 리소스를 데이터소스 하드코딩이 아닌 리소스 생성 및 할당으로 관리하게끔 변경 필요
// 밑의 주석은 리소스 기반 역할 생성 코드이지만, 오류 발생으로 임시 주석 처리
# resource "aws_iam_role" "ecs_task_excution_role" {
#   name = "${local.name}-ecs-excution-role"

#   assume_role_policy = jsonencode({
#     "Version": "2012-10-17",
#     "Statement": [
#       {
#         "Sid": "",
#         "Effect": "Allow",
#         "Principal": {
#           "Service": [
#             "ec2.amazonaws.com"
#           ]
#         },
#         "Action": "sts:AssumeRole"
#       },
#       {
#         "Effect": "Allow",
#         "Action": [
#           "autoscaling:Describe*",
#           "cloudwatch:*",
#           "logs:*",
#           "sns:*",
#           "iam:GetPolicy",
#           "iam:GetPolicyVersion",
#           "iam:GetRole",
#           "oam:ListSinks"
#         ],
#         "Resource": "*"
#       },
#       {
#         "Effect": "Allow",
#         "Action": "iam:CreateServiceLinkedRole",
#         "Resource": "arn:aws:iam::*:role/aws-service-role/events.amazonaws.com/AWSServiceRoleForCloudWatchEvents*",
#         "Condition": {
#           "StringLike": {
#             "iam:AWSServiceName": "events.amazonaws.com"
#           }
#         }
#       },
#       {
#         "Effect": "Allow",
#         "Action": [
#           "oam:ListAttachedLinks"
#         ],
#         "Resource": "arn:aws:oam:*:*:sink/*"
#       },
#       {
#         "Effect": "Allow",
#         "Action": [
#           "s3:*",
#           "s3-object-lambda:*"
#         ],
#         "Resource": "*"
#       },
#       {
#         "Effect": "Allow",
#         "Action": [
#           "ecr:*",
#           "cloudtrail:LookupEvents"
#         ],
#         "Resource": "*"
#       },
#       {
#         "Effect": "Allow",
#         "Action": [
#           "iam:CreateServiceLinkedRole"
#         ],
#         "Resource": "*",
#         "Condition": {
#           "StringEquals": {
#             "iam:AWSServiceName": [
#               "replication.ecr.amazonaws.com"
#             ]
#           }
#         }
#       },
#       {
#         "Effect": "Allow",
#         "Action": [
#           "ecr:GetAuthorizationToken",
#           "ecr:BatchCheckLayerAvailability",
#           "ecr:GetDownloadUrlForLayer",
#           "ecr:BatchGetImage",
#           "logs:CreateLogStream",
#           "logs:PutLogEvents"
#         ],
#         "Resource": "*"
#       }
#     ]
#   })
# }
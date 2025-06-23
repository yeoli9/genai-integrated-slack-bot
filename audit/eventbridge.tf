module "eventbridge" {
  source      = "terraform-aws-modules/eventbridge/aws"
  create_bus  = false
  create_role = false
  role_name   = aws_iam_role.eventbridge.name
  rules = {
    audit = {
      # 이 영역은 IAM 관련 API를 필터링하여 IAM 리소스 변경을 감지합니다.
      event_pattern = jsonencode(
        {
          "source" : ["aws.iam"],
          "detail" : {
            "eventName" : ["AddUserToGroup", "AttachGroupPolicy", "AttachRolePolicy", "AttachUserPolicy", "ChangePassword", "CreateAccessKey", "CreateGroup", "CreateLoginProfile", "CreatePolicy", "CreatePolicyVersion", "CreateRole", "CreateServiceLinkedRole", "CreateUser", "DeleteAccessKey", "DeleteGroup", "DeleteGroupPolicy", "DeleteLoginProfile", "DeletePolicy", "DeletePolicyVersion", "DeleteRole", "DeleteRolePolicy", "DeleteServiceLinkedRole", "DeleteUser", "DeleteUserPolicy", "DetachGroupPolicy", "DetachRolePolicy", "DetachUserPolicy", "PutGroupPolicy", "PutRolePolicy", "PutUserPolicy", "RemoveUserFromGroup", "SetDefaultPolicyVersion", "UpdateAccessKey", "UpdateAssumeRolePolicy", "UpdateGroup", "UpdateLoginProfile", "UpdateRole", "UpdateRoleDescription", "UpdateUser"],
            "requestParameters" : {
              "roleName" : [{
                "anything-but" : ["AmazonSSMRoleForInstancesQuickSetup"]
              }]
            }
          }
        }
      )
      enabled = true
    }
  }

  targets = {
    audit = [
      {
        name = local.name
        arn  = module.lambda.lambda_function_arn
      }
    ]
  }
}

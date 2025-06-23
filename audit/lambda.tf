module "lambda" {
  source      = "terraform-aws-modules/lambda/aws"
  create_role = false
  providers = {
    aws = aws.assistance
  }
  function_name = local.name
  handler       = "lambda_function.lambda_handler"
  timeout       = 30
  environment_variables = {
    ANTHROPIC_TOKENS     = local.anthropic_tokens
    ANTHROPIC_VERSION    = local.anthropic_version
    CHANNEL_ID           = local.channel_id
    MODEL_ID_TEXT        = local.model_id
    SYSTEM_MESSAGE       = local.system_message
    INCOMING_WEBHOOK_URL = local.incoming_webhook_url
  }
  source_path              = "resources/function"
  hash_extra               = filebase64("resources/function/lambda_function.py")
  lambda_role              = aws_iam_role.lambda_role.arn
  compatible_architectures = ["arm64"]
  runtime                  = local.runtime
  layers = [
    module.layer.lambda_layer_arn
  ]
}

module "layer" {
  source = "terraform-aws-modules/lambda/aws"
  providers = {
    aws = aws.assistance
  }

  # Layer configuration
  create_layer             = true
  layer_name               = "requests"
  runtime                  = local.runtime
  compatible_runtimes      = [local.runtime]
  compatible_architectures = ["arm64"]
  build_in_docker          = true
  source_path = [
    {
      pip_requirements = "resources/layer/requirements.txt"
      pip_tmp_dir      = "resources/layer"
      prefix_in_zip    = "python"
    }
  ]
}


resource "aws_lambda_permission" "allow_eventbridge_invoke" {

  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.lambda_function_name
  principal     = "events.amazonaws.com"
  source_arn    = module.eventbridge.eventbridge_rule_arns["audit"]

  depends_on = [
    module.eventbridge,
    module.lambda,
  ]
}

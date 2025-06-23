data "aws_iam_policy" "AWSLambdaBasicExecutionRole" {
  name = "AWSLambdaBasicExecutionRole"
}
data "aws_iam_policy" "AmazonBedrockFullAccess" {
  name = "AmazonBedrockFullAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_basic_role" {
  provider   = aws.assistance
  role       = aws_iam_role.lambda_role.name
  policy_arn = data.aws_iam_policy.AWSLambdaBasicExecutionRole.arn
}
resource "aws_iam_role_policy_attachment" "lambda_invoke_bedrock" {
  provider   = aws.assistance
  role       = aws_iam_role.lambda_role.name
  policy_arn = data.aws_iam_policy.AmazonBedrockFullAccess.arn
}

resource "aws_iam_role" "lambda_role" {
  provider           = aws.assistance
  name               = "${local.service}-${local.name}"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_policy.json
}

resource "aws_iam_role" "eventbridge" {
  name               = "eventbridge-${local.name}"
  assume_role_policy = data.aws_iam_policy_document.eventbridge.json
}

data "aws_iam_policy_document" "eventbridge" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda_assume_policy" {
  provider = aws.assistance
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

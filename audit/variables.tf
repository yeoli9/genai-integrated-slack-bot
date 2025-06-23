locals {
  service              = "assistance"                                                                        # 서비스 이름
  name                 = "notification-audit"                                                                # 서비스 이름
  runtime              = "python3.13"                                                                        # Lambda 런타임
  anthropic_tokens     = "1024"                                                                              # 최대 토큰 수
  anthropic_version    = "bedrock-2023-05-31"                                                                # Bedrock API 버전
  channel_id           = "C092ANSULCB"                                                                       # Slack 채널 ID로 대체
  model_id             = "anthropic.claude-3-5-sonnet-20240620-v1:0"                                         # Bedrock 모델 ID로 대체
  incoming_webhook_url = "https://hooks.slack.com/services/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" # incoming webhook URL로 대체
  # 시스템프롬프트를 정의합니다.
  system_message = <<EOT
    - AWS 서비스에서 발생하는 clouatrail 중 감사로그를 분석해줘.
    - 6하원칙에 따라 상황을 설명하고 When은 KST로 표현해줘. Why는 빼고, Who를 상세히 알려줘. 
    - 불필요한 내용은 제외하고, 핵심적인 내용만 목록 형태로 작성해줘.
    - 강조할 내용은 *굵게* 표시해줘.
    - 코드로 작성할 때는  앞뒤에`` 으로 감싸줘.
    - 코드 블럭으로 작성할 때는 앞뒤에 ```으로 감싸줘.
    - 필요한 경우 한글이 아닌 전문 기술용어를 사용해도 좋아.
    - 감사 로그로 인해 발생 가능한 위험성을 구체적으로 알려줘.
    - 보안 전문가로서 이후에 해야할 일에 대해서 구체적으로 알려줘.
    - 200자 이내로 작성해줘.
  EOT
}

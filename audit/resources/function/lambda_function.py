import json
import os
import boto3
import requests

CHANNEL_ID = os.environ['CHANNEL_ID']
ANTHROPIC_VERSION = os.environ['ANTHROPIC_VERSION']
ANTHROPIC_TOKENS = os.environ['ANTHROPIC_TOKENS']
SYSTEM_MESSAGE = os.environ['SYSTEM_MESSAGE']
MODEL_ID_TEXT = os.environ['MODEL_ID_TEXT']
INCOMING_WEBHOOK_URL = os.environ['INCOMING_WEBHOOK_URL']

try:
    bedrock = boto3.client(service_name="bedrock-runtime",
                           region_name="us-east-1")
except Exception as e:
    print('bed rock initialize error')
    print(e)


def invoke_claude_3(content):
    """
    Invokes Anthropic Claude 3 Sonnet to run an inference using the input
    provided in the request body.

    :param prompt: The prompt that you want Claude 3 to complete.
    :return: Inference response from the model.
    """

    try:
        if bedrock is not None:
            pass

        body = {
            "anthropic_version": ANTHROPIC_VERSION,
            "max_tokens": int(ANTHROPIC_TOKENS),
            "messages": [
                {
                    "role": "user",
                    "content": str(content),
                },
            ],
        }

        if SYSTEM_MESSAGE != "None":
            body["system"] = SYSTEM_MESSAGE

        response = bedrock.invoke_model(
            modelId=MODEL_ID_TEXT,
            body=json.dumps(body),
        )

        # Process and print the response
        body = json.loads(response.get("body").read())

        print("response: {}".format(body))

        result = body.get("content", [])

        for output in result:
            text = output["text"]

        return text

    except Exception as e:
        print("invoke_claude_3: Error: {}".format(e))

        raise e


def send_slack_messages(messages, event_id):
    payload = {
        "channel_id": CHANNEL_ID,
        "message": "AWS 감사 로그",
        "blocks": [
            {
                "type": "section",
                "text": {
                    "type": "mrkdwn",
                    "text": messages
                },
                "accessory": {
                    "type": "button",
                    "text": {
                        "type": "plain_text",
                        "text": "CloudTrail 바로가기"
                    },
                    "value": "click_me_123",
                    "url": f"https://ap-northeast-2.console.aws.amazon.com/cloudtrailv2/home?region=us-east-1#/events?EventId={event_id}",
                    "action_id": "button-action"
                }
            }
        ]
    }
    headers = {
        "Content-Type": "application/json",
    }

    response = requests.request(
        "POST", url=INCOMING_WEBHOOK_URL, json=payload, headers=headers)

    print(response.text)


def lambda_handler(event, context):
    # TODO implement
    print(event)
    event_id = event['detail']['eventID']
    response = invoke_claude_3(
        content=event
    )
    print(response)
    send_slack_messages(response, event_id)
    print(response)
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }

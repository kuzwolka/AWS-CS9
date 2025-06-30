import boto3
import requests
from botocore.exceptions import ClientError

# Bedrock 클라이언트 생성
client = boto3.client("bedrock-runtime", region_name="ap-northeast-1")
model_id = "anthropic.claude-3-haiku-20240307-v1:0"

# 분석할 웹 이미지의 URL
image_url = "https://aws9-beomtaekkim-testbkt.s3.ap-northeast-1.amazonaws.com/sample-image.png"  # <- 여기에 실제 이미지 URL 입력

# 웹에서 이미지 다운로드
response = requests.get(image_url)
if response.status_code != 200:
    raise Exception("이미지 다운로드 실패")


img_bytes = response.content

# 사용자 메시지 및 이미지 분석 요청 생성
user_message = "서문 없이 사진을 분석한 결과를 간단히 작성해 주세요."
conversation = [
    {
        "role": "user",
        "content": [
            { "text": user_message },
            {
                "image": {
                    "format": "png",  # 이미지 포맷이 JPEG이면 'jpeg'로 변경
                    "source": {
                        "bytes": img_bytes
                    }
                }
            }
        ]
    }
]

# Bedrock 호출
try:
    response = client.converse(
        modelId=model_id,
        messages=conversation,
        inferenceConfig={"maxTokens": 4096, "temperature": 0.5, "topP": 0.9},
    )

    response_text = response["output"]["message"]["content"][0]["text"]
    print(response_text)

except (ClientError, Exception) as e:
    print(f"ERROR: Can't invoke '{model_id}'. Reason: {e}")
    exit(1)

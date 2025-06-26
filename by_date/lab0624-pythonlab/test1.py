import boto3, json

ec2 = boto3.client('ec2',region_name='ap-northeast-2')
bedrock = boto3.client('bedrock',region_name='ap-northeast-2')

response = ec2.describe_vpcs()
response2 = bedrock.list_foundation_models()

print(json.dumps(response2, indent=2))
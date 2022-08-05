import boto3

PROFILE = "sbx-mfa"
BUCKET = "qgab-tfstates-sbx"

session = boto3.Session(profile_name=PROFILE)
s3 = session.resource("s3")
bucket = s3.Bucket(BUCKET)
bucket.object_versions.delete()

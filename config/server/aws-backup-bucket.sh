#!/bin/bash
# One-time: create the S3 bucket and upload-only IAM user for database
# backups (see backup.sh). Run in AWS CloudShell (us-east-1) or anywhere with
# admin AWS credentials. Then create an access key for the user and run
# config/server/install-backup.sh --keys.
set -euo pipefail

bucket=sharkipedia-db-backups
user=sharkipedia-backup
region=us-east-1

aws s3api create-bucket --bucket "$bucket" --region "$region"
aws s3api put-public-access-block --bucket "$bucket" --public-access-block-configuration \
  BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true
aws s3api put-bucket-versioning --bucket "$bucket" --versioning-configuration Status=Enabled
aws s3api put-bucket-lifecycle-configuration --bucket "$bucket" --lifecycle-configuration '{
  "Rules": [{
    "ID": "expire-after-14-days",
    "Status": "Enabled",
    "Filter": {},
    "Expiration": {"Days": 14},
    "NoncurrentVersionExpiration": {"NoncurrentDays": 1},
    "AbortIncompleteMultipartUpload": {"DaysAfterInitiation": 7}
  }]
}'

aws iam create-user --user-name "$user"
aws iam put-user-policy --user-name "$user" --policy-name upload-backups --policy-document "{
  \"Version\": \"2012-10-17\",
  \"Statement\": [{
    \"Effect\": \"Allow\",
    \"Action\": \"s3:PutObject\",
    \"Resource\": \"arn:aws:s3:::$bucket/*\"
  }]
}"

echo "Done. Create the server's key with: aws iam create-access-key --user-name $user"

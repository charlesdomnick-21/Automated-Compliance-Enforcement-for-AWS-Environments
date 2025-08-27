#!/bin/bash
set -e

echo "Running S3 versioning remediation for bucket: $RESOURCE_ID"

VERSIONING_STATUS=$(aws s3api get-bucket-versioning --bucket "$RESOURCE_ID" --query 'Status' --output text || echo "Disabled")
echo "Current versioning status: $VERSIONING_STATUS"

if [ "$VERSIONING_STATUS" != "Enabled" ]; then
    echo "Enabling versioning for $RESOURCE_ID"
    aws s3api put-bucket-versioning --bucket "$RESOURCE_ID" --versioning-configuration Status=Enabled
else
    echo "Bucket $RESOURCE_ID already has versioning enabled"
fi


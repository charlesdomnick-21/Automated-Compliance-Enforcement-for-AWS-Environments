#!/bin/bash
set -euo pipefail

RESOURCE_ID="$1"
RESOURCE_TYPE="$2"

echo "Enabling encryption for DynamoDB table: $RESOURCE_ID"

# AWS Config passes DynamoDB resource IDs as just the table name
TABLE_NAME="$RESOURCE_ID"

echo "Using table name: $TABLE_NAME"

# Check if table exists first
if ! aws dynamodb describe-table --table-name "$TABLE_NAME" 2>/dev/null; then
    echo "Error: Table $TABLE_NAME does not exist or cannot be accessed"
    exit 1
fi

# Enable encryption using AWS CLI
echo "Enabling encryption for table: $TABLE_NAME"
aws dynamodb update-table \
    --table-name "$TABLE_NAME" \
    --sse-specification '{"Enabled": true}'

echo "Successfully enabled encryption for DynamoDB table: $TABLE_NAME"

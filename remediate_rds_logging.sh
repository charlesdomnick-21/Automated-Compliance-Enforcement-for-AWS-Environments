#!/bin/bash
set -euo pipefail

RESOURCE_ID="$1"
RESOURCE_TYPE="$2"

echo "Enabling logging for RDS instance: $RESOURCE_ID"

# Check if the resource ID is a DbiResourceId (starts with db-)
if [[ "$RESOURCE_ID" == db-* ]]; then
    echo "Detected DbiResourceId format, converting to DB instance identifier..."
    
    # Get the actual DB instance identifier using describe-db-instances
    DB_INSTANCE_ID=$(aws rds describe-db-instances \
        --query "DBInstances[?DbiResourceId=='$RESOURCE_ID'].DBInstanceIdentifier" \
        --output text)
    
    if [ -z "$DB_INSTANCE_ID" ]; then
        echo "Error: Could not find RDS instance with DbiResourceId: $RESOURCE_ID"
        exit 1
    fi
    
    echo "Converted DbiResourceId $RESOURCE_ID to DBInstanceIdentifier: $DB_INSTANCE_ID"
    RESOURCE_ID="$DB_INSTANCE_ID"
fi

# Check if RDS instance exists first
if ! aws rds describe-db-instances --db-instance-identifier "$RESOURCE_ID" &>/dev/null; then
    echo "Error: RDS instance $RESOURCE_ID does not exist or cannot be accessed"
    exit 1
fi

echo "RDS instance found. Enabling CloudWatch logs..."

# Enable CloudWatch logs export
aws rds modify-db-instance \
    --db-instance-identifier "$RESOURCE_ID" \
    --cloudwatch-logs-export-configuration '{"EnableLogTypes":["audit","error","general","slowquery"]}' \
    --apply-immediately

echo "Successfully enabled logging for RDS instance: $RESOURCE_ID"

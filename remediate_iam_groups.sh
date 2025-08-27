#!/bin/bash
set -euo pipefail

GROUP="${1:-}"

if [[ -z "$GROUP" ]]; then
  echo "No group passed. Skipping group remediation."
  exit 0
fi

echo "Checking group: $GROUP"

# Check if input is a GROUP ID (starts with AGPA) and try to convert to name
if [[ "$GROUP" == AGPA* ]]; then
    echo "DEBUG: Input appears to be a group ID, attempting to convert to group name..."
    GROUP_NAME=$(aws iam list-groups --query "Groups[?GroupId=='$GROUP'].GroupName" --output text)
    if [[ -n "$GROUP_NAME" ]]; then
        echo "DEBUG: Converted group ID $GROUP to group name: $GROUP_NAME"
        GROUP="$GROUP_NAME"
    else
        echo "DEBUG: Could not convert group ID $GROUP to name. Using as-is."
    fi
fi

# Skip the default Developers group - never delete it
if [[ "$GROUP" == "Developers" ]]; then
    echo "Skipping default group Developers - will not be deleted."
    exit 0
fi

# Check if group exists
if ! aws iam get-group --group-name "$GROUP" 2>/dev/null; then
    echo "Group $GROUP does not exist. Skipping."
    exit 0
fi

# Check if group has any users (with timeout safety)
echo "Checking users in group: $GROUP"
USERS=$(timeout 30s aws iam get-group --group-name "$GROUP" --query 'Users[*].UserName' --output text 2>&1 || echo "TIMEOUT_OR_ERROR")

if [[ "$USERS" == *"TIMEOUT_OR_ERROR"* ]]; then
    echo "WARNING: User check timed out for group $GROUP. Skipping to avoid incorrect deletion."
    exit 0
fi

if [[ -z "$USERS" ]]; then
  # Group is empty - delete it
  echo "Group $GROUP has no users. Deleting empty group."
  aws iam delete-group --group-name "$GROUP"
  echo "Successfully deleted empty group: $GROUP"
else
  # Group has users - no action needed
  echo "Group $GROUP has users: $USERS - No action needed."
fi

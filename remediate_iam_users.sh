#!/bin/bash
set -euo pipefail

USER="${1:-}"

if [[ -z "$USER" ]]; then
  echo "No user passed. Skipping user remediation."
  exit 0
fi

echo "Remediating user: $USER"

# Check if input is a USER ID (starts with AIDA) and try to convert to username
if [[ "$USER" == AIDA* ]]; then
    echo "DEBUG: Input appears to be a user ID, attempting to convert to username..."
    USER_NAME=$(aws iam list-users --query "Users[?UserId=='$USER'].UserName" --output text)
    if [[ -n "$USER_NAME" ]]; then
        echo "DEBUG: Converted user ID $USER to username: $USER_NAME"
        USER="$USER_NAME"
    else
        echo "DEBUG: Could not convert user ID $USER to username. Using as-is."
    fi
fi

# Check if user exists
if ! aws iam get-user --user-name "$USER" 2>/dev/null; then
    echo "User $USER does not exist. Skipping."
    exit 0
fi

# Ensure default group exists
if ! aws iam get-group --group-name "Developers" 2>/dev/null; then
    echo "Creating default group: Developers"
    aws iam create-group --group-name "Developers"
fi

# Simply add user to Developers group (safe to run multiple times)
aws iam add-user-to-group --user-name "$USER" --group-name "Developers"
echo "Successfully ensured $USER is in Developers group"

echo "Remediation completed"

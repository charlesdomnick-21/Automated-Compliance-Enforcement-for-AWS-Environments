#!/bin/bash
set -euo pipefail

RULE="${CONFIG_RULE_NAME:-}"
RES="${RESOURCE_ID:-}"

echo "Auto-remediation dispatcher started"
echo "Rule: ${RULE}, Resource: ${RES}"

case "$RULE" in
  IAMUserGroupMembershipCheck)
    echo "Processing non-compliant USER: $RES"
    ./remediate_iam_users.sh "$RES"
    ;;
  IAMGroupHasUsers)
    echo "Processing non-compliant GROUP: $RES"
    ./remediate_iam_groups.sh "$RES"
    ;;
  *)
    echo "Unknown rule or automated scan. Processing as potential non-compliant resource: $RES"
    # Try both - scripts will self-skip if not applicable
    ./remediate_iam_users.sh "$RES" || true
    ./remediate_iam_groups.sh "$RES" || true
    ;;
esac

echo "Auto-remediation completed for: $RES"

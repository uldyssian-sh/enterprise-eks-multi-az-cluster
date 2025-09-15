#!/bin/bash

set -e

echo "🔍 Checking prerequisites for enterprise EKS deployment..."

# Check required tools
REQUIRED_TOOLS=("terraform" "kubectl" "aws" "helm" "git")
MISSING_TOOLS=()

for tool in "${REQUIRED_TOOLS[@]}"; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        MISSING_TOOLS+=("$tool")
    else
        if $tool --version >/dev/null 2>&1; then
            VERSION=$($tool --version 2>/dev/null | head -n1)
        else
            VERSION="unknown"
        fi
        echo "✅ $tool: $VERSION"
    fi
done

if [ ${#MISSING_TOOLS[@]} -ne 0 ]; then
    echo "❌ Missing required tools: ${MISSING_TOOLS[*]}"
    exit 1
fi

# Check AWS credentials
echo "🔐 Checking AWS credentials..."
if aws sts get-caller-identity >/dev/null 2>&1; then
    CALLER_IDENTITY=$(aws sts get-caller-identity)
    ACCOUNT=$(echo "$CALLER_IDENTITY" | jq -r '.Account')
    USER=$(echo "$CALLER_IDENTITY" | jq -r '.Arn')
    echo "✅ AWS credentials valid: $USER (Account: $ACCOUNT)"
else
    echo "❌ AWS credentials not configured"
    exit 1
fi

# Check AWS permissions
echo "🔑 Checking AWS permissions..."
REQUIRED_PERMISSIONS=("eks:CreateCluster" "ec2:CreateVpc" "iam:CreateRole")
for perm in "${REQUIRED_PERMISSIONS[@]}"; do
    if aws iam simulate-principal-policy --policy-source-arn "$USER" --action-names "$perm" --resource-arns "*" --query 'EvaluationResults[0].EvalDecision' --output text 2>/dev/null | grep -q "allowed"; then
        echo "✅ $perm: allowed"
    else
        echo "⚠️ $perm: may be restricted"
    fi
done

# Check disk space
echo "💾 Checking disk space..."
AVAILABLE_SPACE=$(df -h . | awk 'NR==2 {print $4}')
SPACE_NUM=${AVAILABLE_SPACE//[^0-9.]/}
SPACE_UNIT=${AVAILABLE_SPACE//[0-9.]/}

case "$SPACE_UNIT" in
    "G"|"g") SPACE_GB="$SPACE_NUM" ;;
    "T"|"t") SPACE_GB=$((SPACE_NUM * 1024)) ;;
    "M"|"m") SPACE_GB=$((SPACE_NUM / 1024)) ;;
    "K"|"k") SPACE_GB=$((SPACE_NUM / 1024 / 1024)) ;;
    *) SPACE_GB=0 ;;
esac

if [ "${SPACE_GB%.*}" -gt 10 ]; then
    echo "✅ Disk space: ${AVAILABLE_SPACE} available"
else
    echo "⚠️ Low disk space: ${AVAILABLE_SPACE} (recommend 10G+)"
fi

echo "✅ Prerequisites check completed successfully!"
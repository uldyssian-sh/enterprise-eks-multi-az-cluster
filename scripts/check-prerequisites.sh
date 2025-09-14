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
        VERSION=$(command -v "$tool" && $tool --version 2>/dev/null | head -n1 || echo "unknown")
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
    ACCOUNT=$(aws sts get-caller-identity --query Account --output text)
    USER=$(aws sts get-caller-identity --query Arn --output text)
    echo "✅ AWS credentials valid: $USER (Account: $ACCOUNT)"
else
    echo "❌ AWS credentials not configured"
    exit 1
fi

# Check AWS permissions
echo "🔑 Checking AWS permissions..."
REQUIRED_PERMISSIONS=("eks:CreateCluster" "ec2:CreateVpc" "iam:CreateRole")
for perm in "${REQUIRED_PERMISSIONS[@]}"; do
    if aws iam simulate-principal-policy --policy-source-arn "$(aws sts get-caller-identity --query Arn --output text)" --action-names "$perm" --resource-arns "*" --query 'EvaluationResults[0].EvalDecision' --output text 2>/dev/null | grep -q "allowed"; then
        echo "✅ $perm: allowed"
    else
        echo "⚠️ $perm: may be restricted"
    fi
done

# Check disk space
echo "💾 Checking disk space..."
AVAILABLE_SPACE=$(df -h . | awk 'NR==2 {print $4}' | sed 's/G//')
if [ "${AVAILABLE_SPACE%.*}" -gt 10 ]; then
    echo "✅ Disk space: ${AVAILABLE_SPACE}G available"
else
    echo "⚠️ Low disk space: ${AVAILABLE_SPACE}G (recommend 10G+)"
fi

echo "✅ Prerequisites check completed successfully!"
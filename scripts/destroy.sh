#!/bin/bash

set -e

ENVIRONMENT=${1:-dev}

echo "🗑️ Destroying EKS cluster: $ENVIRONMENT"

cd "terraform/environments/$ENVIRONMENT"

echo "💥 Destroying infrastructure..."
terraform destroy -auto-approve -input=false >/dev/null 2>&1

echo "✅ Infrastructure destroyed!"
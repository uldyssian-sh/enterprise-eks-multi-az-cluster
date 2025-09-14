#!/bin/bash

set -e

ENV=${1:-dev}
REGION=${2:-us-west-2}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "🚀 Deploying enterprise EKS: $ENV"

# Deploy infrastructure
cd "$PROJECT_ROOT/terraform/environments/$ENV"
terraform init
terraform plan -out=tfplan
terraform apply -auto-approve tfplan

# Configure kubectl
aws eks --region "$REGION" update-kubeconfig --name "eks-multi-az-cluster-$ENV"

# Wait for nodes
kubectl wait --for=condition=Ready nodes --all --timeout=300s

# Deploy security stack
cd "$PROJECT_ROOT"
echo "📦 Installing security stack..."
./scripts/install-security.sh || { echo "❌ Security installation failed"; exit 1; }

# Deploy monitoring
echo "📊 Deploying monitoring..."
kubectl apply -f k8s/monitoring/ || { echo "❌ Monitoring deployment failed"; exit 1; }

# Apply policies
echo "📜 Applying policies..."
kubectl apply -f k8s/policies/ || echo "⚠️ Some policies may have failed (non-critical)"

echo "✅ Enterprise EKS deployed: $ENV"
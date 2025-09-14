#!/bin/bash

set -e

NODES=$(kubectl get nodes --no-headers 2>/dev/null | grep Ready | wc -l | tr -d ' ')
PODS=$(kubectl get pods -n kube-system --no-headers 2>/dev/null | grep Running | wc -l | tr -d ' ')
echo "✅ $NODES nodes, $PODS pods"
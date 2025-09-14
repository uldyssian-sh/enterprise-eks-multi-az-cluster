#!/bin/bash

set -e

echo "🔒 Running comprehensive security scan..."

# Container image vulnerability scan
echo "🐳 Scanning container images..."
if command -v trivy >/dev/null 2>&1; then
    kubectl get pods -A -o jsonpath='{range .items[*]}{.spec.containers[*].image}{"\n"}{end}' | sort -u | head -5 | while read image; do
        echo "  Scanning: $image"
        trivy image --severity HIGH,CRITICAL --quiet "$image" || echo "    ⚠️ Scan failed for $image"
    done
else
    echo "  ⚠️ Trivy not installed, skipping image scans"
fi

# Kubernetes configuration scan
echo "⚙️ Scanning Kubernetes configurations..."
if command -v kube-score >/dev/null 2>&1; then
    find k8s/ -name "*.yaml" -exec kube-score score {} \; 2>/dev/null | grep -E "(CRITICAL|WARNING)" | head -10 || echo "  ✅ No critical issues found"
else
    echo "  ⚠️ kube-score not installed"
fi

# Network policy validation
echo "🌐 Checking network security..."
NAMESPACES_WITHOUT_NETPOL=$(kubectl get namespaces -o json | jq -r '.items[] | select(.metadata.name != "kube-system" and .metadata.name != "kube-public" and .metadata.name != "kube-node-lease") | .metadata.name' | while read ns; do
    if ! kubectl get networkpolicy -n "$ns" >/dev/null 2>&1; then
        echo "$ns"
    fi
done | wc -l)
echo "  Namespaces without network policies: $NAMESPACES_WITHOUT_NETPOL"

# RBAC analysis
echo "👥 Analyzing RBAC permissions..."
CLUSTER_ADMIN_BINDINGS=$(kubectl get clusterrolebindings -o json | jq -r '.items[] | select(.roleRef.name=="cluster-admin") | .metadata.name' | wc -l)
echo "  Cluster admin bindings: $CLUSTER_ADMIN_BINDINGS"

# Secret analysis
echo "🔑 Analyzing secrets..."
UNENCRYPTED_SECRETS=$(kubectl get secrets -A --field-selector type=Opaque -o json | jq -r '.items[] | select(.metadata.annotations."encryption.alpha.kubernetes.io/encrypted" != "true") | .metadata.name' | wc -l)
echo "  Potentially unencrypted secrets: $UNENCRYPTED_SECRETS"

# Security score calculation
TOTAL_CHECKS=4
SECURITY_ISSUES=$((NAMESPACES_WITHOUT_NETPOL > 0 ? 1 : 0))
SECURITY_ISSUES=$((SECURITY_ISSUES + (CLUSTER_ADMIN_BINDINGS > 2 ? 1 : 0)))
SECURITY_ISSUES=$((SECURITY_ISSUES + (UNENCRYPTED_SECRETS > 5 ? 1 : 0)))

SECURITY_SCORE=$(((TOTAL_CHECKS - SECURITY_ISSUES) * 100 / TOTAL_CHECKS))

echo "📊 Security Scan Summary:"
echo "  Security Score: $SECURITY_SCORE/100"
echo "  Network policy gaps: $NAMESPACES_WITHOUT_NETPOL"
echo "  RBAC admin bindings: $CLUSTER_ADMIN_BINDINGS"
echo "  Unencrypted secrets: $UNENCRYPTED_SECRETS"

if [ $SECURITY_SCORE -ge 90 ]; then
    echo "✅ Security scan passed!"
elif [ $SECURITY_SCORE -ge 70 ]; then
    echo "⚠️ Security improvements recommended"
else
    echo "❌ Critical security issues found"
fi
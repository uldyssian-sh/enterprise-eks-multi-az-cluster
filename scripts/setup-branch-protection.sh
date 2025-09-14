#!/bin/bash

set -e

echo "🛡️ Setting up branch protection for main branch"

# Create JSON payload
cat > /tmp/protection.json << 'EOF'
{
  "required_status_checks": {
    "strict": true,
    "contexts": [
      "Security Scan",
      "Terraform Validation", 
      "Kubernetes Validation"
    ]
  },
  "enforce_admins": true,
  "required_pull_request_reviews": {
    "required_approving_review_count": 1,
    "dismiss_stale_reviews": true,
    "require_code_owner_reviews": false
  },
  "restrictions": null,
  "allow_force_pushes": false,
  "allow_deletions": false
}
EOF

# Apply protection
echo "📋 Applying branch protection rules..."
gh api repos/uldyssian-sh/enterprise-eks-multi-az-cluster/branches/main/protection \
  --method PUT \
  --input /tmp/protection.json

echo "✅ Branch protection configured successfully!"
echo "🔒 Main branch is now protected with:"
echo "  - Required PR reviews (1+)"
echo "  - Required status checks"
echo "  - No force pushes"
echo "  - No deletions"

# Cleanup
rm -f /tmp/protection.json
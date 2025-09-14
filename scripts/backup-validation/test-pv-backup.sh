#!/bin/bash
set -e
echo "💾 Testing PV backup..."
kubectl get pv --no-headers | wc -l | xargs -I {} echo "Total PVs: {}"
kubectl get pv -o jsonpath='{range .items[*]}{.metadata.annotations.backup\.kubernetes\.io/enabled}{"\n"}{end}' | grep -c "true" | xargs -I {} echo "Backup-enabled PVs: {}"
echo "✅ PV backup test completed"
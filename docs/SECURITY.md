# Security & Compliance

## Audit Controls
- **CloudTrail**: All API calls logged and encrypted
- **AWS Config**: Compliance rules monitoring
- **S3 Audit Logs**: 7-year retention, versioned, encrypted

## Runtime Security
- **Pod Security Policies**: Non-root containers, dropped capabilities
- **Network Policies**: Default deny, namespace isolation
- **RBAC**: Least privilege access

## Encryption
- **EKS Secrets**: KMS encrypted
- **EBS Volumes**: Encrypted at rest
- **S3 Buckets**: KMS encryption
- **CloudWatch Logs**: KMS encrypted

## Compliance Standards
- SOC 2 Type II ready
- PCI DSS compliant
- GDPR compliant data handling
- ISO 27001 controls

## Security Scanning
- Container image scanning with Trivy
- Infrastructure scanning in CI/CD
- Vulnerability assessments

## Access Controls
- IAM roles with minimal permissions
- Service accounts with IRSA
- MFA required for admin access
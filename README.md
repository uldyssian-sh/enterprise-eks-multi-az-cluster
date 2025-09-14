# AWS EKS Multi-AZ Cluster

Enterprise-grade AWS EKS cluster deployment with multi-availability zone setup, security best practices, and automated CI/CD.

## Features

- **Multi-AZ Setup**: Cluster spans across 3 availability zones for high availability
- **Security**: KMS encryption, security groups, RBAC, network policies
- **Automation**: Terraform infrastructure as code with GitHub Actions CI/CD
- **Monitoring**: CloudWatch logging and metrics
- **Cost Optimized**: Uses t3.medium instances for cost efficiency

## Architecture

```
┌──────────────────────────────────────────────────────────────┐
│                        AWS Region (us-west-2)               │
├─────────────────┬─────────────────┬─────────────────────────┤
│       AZ-a      │       AZ-b      │         AZ-c            │
│  ┌───────────┐  │  ┌───────────┐  │    ┌───────────┐        │
│  │Public Sub │  │  │Public Sub │  │    │Public Sub │        │
│  │10.0.101/24│  │  │10.0.102/24│  │    │10.0.103/24│        │
│  └───────────┘  │  └───────────┘  │    └───────────┘        │
│  ┌───────────┐  │  ┌───────────┐  │    ┌───────────┐        │
│  │Private Sub│  │  │Private Sub│  │    │Private Sub│        │
│  │10.0.1/24  │  │  │10.0.2/24  │  │    │10.0.3/24  │        │
│  │Worker Node│  │  │Worker Node│  │    │Worker Node│        │
│  └───────────┘  │  └───────────┘  │    └───────────┘        │
└─────────────────┴─────────────────┴─────────────────────────┘
```

## Quick Start

### Prerequisites

- AWS CLI configured with appropriate permissions
- Terraform >= 1.0
- kubectl
- Git

### Deploy

```bash
# Clone repository
git clone https://github.com/your-username/aws-eks-multi-az-cluster.git
cd aws-eks-multi-az-cluster

# Deploy to dev environment
./scripts/deploy.sh dev us-west-2

# Validate deployment
./scripts/validate-cluster.sh
```

### Cleanup

```bash
./scripts/destroy.sh dev
```

## Project Structure

```
.
├── terraform/
│   ├── modules/
│   │   ├── vpc/          # VPC with multi-AZ subnets
│   │   ├── eks/          # EKS cluster and node groups
│   │   └── security/     # Security groups and KMS
│   └── environments/
│       ├── dev/          # Development environment
│       ├── staging/      # Staging environment
│       └── prod/         # Production environment
├── k8s/
│   ├── rbac/            # RBAC configurations
│   ├── network-policies/ # Network security policies
│   └── manifests/       # Application manifests
├── scripts/             # Deployment and utility scripts
├── .github/workflows/   # CI/CD pipelines
└── docs/               # Documentation
```

## Security Features

- **Encryption**: EKS secrets encrypted with KMS
- **Network Security**: Private subnets for worker nodes
- **RBAC**: Role-based access control
- **Network Policies**: Pod-to-pod communication restrictions
- **Security Groups**: Least privilege access
- **Vulnerability Scanning**: Trivy security scans in CI/CD

## Monitoring

- CloudWatch container insights
- EKS control plane logging
- Metrics server for resource monitoring

## Cost Optimization

- t3.medium instances (cost-effective)
- Cluster autoscaler for dynamic scaling
- Spot instances support (configurable)

## Contributing

1. Fork the repository
2. Create feature branch
3. Make changes
4. Run security scans
5. Submit pull request

## License

MIT License
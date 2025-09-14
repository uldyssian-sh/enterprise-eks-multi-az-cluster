# Quick Start Guide

Get your enterprise EKS cluster running in 15 minutes with zero-touch automation.

## Prerequisites

- AWS CLI configured with appropriate permissions
- kubectl installed (v1.28+)
- Terraform installed (v1.5+)
- Docker installed
- Bash shell

## 🚀 One-Command Deployment

```bash
# Clone repository
git clone https://github.com/uldyssian-sh/enterprise-eks-multi-az-cluster.git
cd enterprise-eks-multi-az-cluster

# Deploy development environment (15 minutes)
./scripts/fully-automated-deploy.sh dev

# Deploy production environment (20 minutes)
./scripts/fully-automated-deploy.sh prod
```

## 📊 Verify Deployment

```bash
# Check cluster status
kubectl get nodes

# Verify all pods are running
kubectl get pods -A

# Access Grafana dashboard
kubectl port-forward -n monitoring svc/grafana 3000:3000
# Open http://localhost:3000

# Access ArgoCD
kubectl port-forward -n argocd svc/argocd-server 8080:80
# Open http://localhost:8080
```

## 🔧 Configuration

### Environment Variables
```bash
export AWS_REGION=us-west-2
export CLUSTER_NAME=eks-multi-az-cluster
export ENVIRONMENT=dev
```

### Terraform Variables
Edit `terraform/environments/dev/terraform.tfvars`:
```hcl
cluster_name = "my-eks-cluster"
region      = "us-west-2"
environment = "dev"
```

## 🧹 Cleanup

```bash
# Remove all resources
./scripts/cleanup.sh dev
```

## 📚 Next Steps

- [System Architecture](System-Architecture) - Understand the platform
- [Security Standards](Security-Standards) - Configure security
- [Monitoring Setup](Monitoring-Observability) - Set up observability
- [Troubleshooting](Troubleshooting) - Common issues
# Enterprise EKS Multi-AZ Cluster

<div align="center">
  <img src="https://d2908q01vomqb2.cloudfront.net/fe2ef495a1152561572949784c16bf23abb28057/2019/01/23/eks-logo-1.png" alt="Enterprise EKS" width="400"/>
  
  [![Terraform](https://img.shields.io/badge/Terraform-1.5+-623CE4.svg)](https://www.terraform.io/)
  [![AWS EKS](https://img.shields.io/badge/AWS-EKS-FF9900.svg)](https://aws.amazon.com/eks/)
  [![Multi-AZ](https://img.shields.io/badge/Multi--AZ-High%20Availability-green.svg)](https://aws.amazon.com/about-aws/global-infrastructure/regions_az/)
</div>

## 🏢 Overview

Enterprise-grade, highly available EKS cluster spanning multiple Availability Zones. Designed for production workloads with advanced security, monitoring, and disaster recovery capabilities.

## 🚀 Quick Deployment

```bash
# Clone repository
git clone https://github.com/uldyssian-sh/enterprise-eks-multi-az-cluster.git
cd enterprise-eks-multi-az-cluster

# Configure variables
cp terraform.tfvars.example terraform.tfvars

# Deploy infrastructure
terraform init
terraform apply

# Update kubeconfig
aws eks update-kubeconfig --region us-west-2 --name enterprise-eks-cluster
```

## ⚡ Features

- **Multi-AZ Deployment**: Nodes across 3 availability zones
- **Auto Scaling**: Cluster and pod autoscaling
- **Security**: Private subnets, IAM roles, network policies
- **Monitoring**: CloudWatch, Prometheus, Grafana

## 📚 Documentation

- [Architecture Guide](https://github.com/uldyssian-sh/enterprise-eks-multi-az-cluster/wiki/Architecture)
- [Deployment Guide](https://github.com/uldyssian-sh/enterprise-eks-multi-az-cluster/wiki/Deployment)
- [Security Hardening](https://github.com/uldyssian-sh/enterprise-eks-multi-az-cluster/wiki/Security)

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

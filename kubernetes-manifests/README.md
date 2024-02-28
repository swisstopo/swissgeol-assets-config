# Kubernetes Deployment

## Connect to Kubernetes Cluster

## Prerequisites

1. Create secret and access key for your [AWS account](https://us-east-1.console.aws.amazon.com/iamv2/home?region=us-east-1#/security_credentials?section=IAM_credentials)
2. Download, install and configure [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
3. Download, install and configure [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/#install-nonstandard-package-tools)
4. Download, install and configure [helm](https://helm.sh/docs/intro/install/)

## Deploy Application

Use the following commands to delete and configure the swissgeol-asset application on the cluster.

Valid actions are `delete` and `configure`.
Valid contexts are `dev`, `int` and `prod`.

```bash
# Delete all the resources in the namespace. Use with caution!
.\swissgeol-asset.ps1 -action delete -context dev

# Configure the application on the cluster
.\swissgeol-asset.ps1 -action configure -context dev
```

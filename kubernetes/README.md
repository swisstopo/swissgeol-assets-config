# Kubernetes Deployment

## Connect to Kubernetes Cluster

## Prerequisites

1. Create secret and access key for your [AWS account](https://us-east-1.console.aws.amazon.com/iamv2/home?region=us-east-1#/security_credentials?section=IAM_credentials)
2. Download, install and configure [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
3. Download, install and configure [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/#install-nonstandard-package-tools)
4. Download, install and configure [helm](https://helm.sh/docs/intro/install/)
5. Keel is deployed into cluster [keel installation](https://keel.sh/docs/#installation)

## Validate Application

Validate deployment with
```bash
helm lint helm/swissgeol-assets
```
or pretend to install the chart to the cluster and if there is some issue it will show the error.
```bash
helm install --dry-run swissgeol-assets helm/swissgeol-assets
```

## Deploy Application

Use the following commands to install and uninstall the swissgeol-asset application on the cluster.

Valid actions are `install` and `uninstall`.
Valid contexts are `dev`, `int` and `prod`.

```bash
# Installs the application on the cluster
.\swissgeol-assets.ps1 -action configure -context dev

# Uninstall the application from the cluster. Use with caution!
.\swissgeol-assets.ps1 -action install -context dev
```

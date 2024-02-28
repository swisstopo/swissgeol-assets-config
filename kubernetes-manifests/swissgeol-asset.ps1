param (
    [Parameter(Mandatory=$true)]
    [ValidateSet("delete","configure")]
    [string]$action,

    [Parameter(Mandatory=$true)]
    [ValidateSet("dev","int","------prod")]
    [string]$context
)

# Default namespace
$namespace = "swissgeol-asset"

# Get the base path using the location of the script file
$basePath = Split-Path -Parent $MyInvocation.MyCommand.Definition

function PrepareContext {
  param (
      [string]$env
  )

  Write-Output "Prepare kubectl context: $env"
  kubectl config use-context $namespace-$env
  kubectl apply -f $basePath\namespaces\swissgeol-asset.yaml
  kubectl config set-context --current --namespace=$namespace

  # Configure helm locally
  helm repo add keel https://charts.keel.sh
  helm repo update
}

if ($action -eq 'delete') {
    Write-Output "Detele all resources on $context in the namespace $namespace"
    PrepareContext -env $context
    kubectl delete all --all --namespace=$namespace
    kubectl delete secret --all --namespace=$namespace
    #helm uninstall $namespace-keel keel/keel --namespace=$namespace
}
elseif ($action -eq 'configure') {
    Write-Output "Apply manifests on $context in the namespace $namespace"
    PrepareContext -env $context

    # helm install --name $namespace-keel --namespace=$namespace keel/keel 

    kubectl apply -f $basePath\secrets\geoadmin-ghcr-registry.yaml
    kubectl apply -f $basePath\secrets\swissgeol-asset.$context.yaml

    kubectl apply -f $basePath\deployments\api.yaml
    kubectl apply -f $basePath\deployments\app.yaml
    kubectl apply -f $basePath\deployments\gotrue.yaml
    kubectl apply -f $basePath\deployments\elasticsearch.yaml
    kubectl apply -f $basePath\deployments\kibana.yaml

    kubectl apply -f $basePath\services\api.yaml
    kubectl apply -f $basePath\services\app.yaml
    kubectl apply -f $basePath\services\gotrue.yaml
    kubectl apply -f $basePath\services\elasticsearch.yaml
    kubectl apply -f $basePath\services\kibana.yaml

    kubectl apply -f $basePath\custom-resource-definitions\ingress-route.$context.yaml
    kubectl apply -f $basePath\custom-resource-definitions\middleware.yaml
}
else {
    Write-Output "Invalid action specified: $action"
}

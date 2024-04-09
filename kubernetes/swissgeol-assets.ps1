param (
    [Parameter(Mandatory=$true)]
    [ValidateSet("install","uninstall")]
    [string]$action,

    [Parameter(Mandatory=$true)]
    [ValidateSet("dev","int","prod")]
    [string]$context
)

# Default namespace
$namespace = "swissgeol-assets"
$name = "swissgeol-assets"

Write-Output "*** Prepare kubectl context '$namespace-$context' ***"
kubectl config use-context $namespace-$context
kubectl create namespace $namespace --dry-run=client -o yaml | kubectl apply -f - 
kubectl config set-context --current --namespace=$namespace

# Configure helm locally
# helm repo add keel https://charts.keel.sh
# helm repo update

Write-Output "*** Execute action '$action' on context '$namespace-$context' ***"
if ($action -eq 'install') {
    helm install $name helm/swissgeol-assets --namespace=$namespace --values helm/swissgeol-assets/values-$context.yaml --values helm/swissgeol-assets/secrets-$context.yaml
} elseif ($action -eq 'uninstall') {
    helm uninstall $name --namespace=$namespace
} else {
    Write-Output "Invalid action '$action'"
}

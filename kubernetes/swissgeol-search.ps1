param (
    [Parameter(Mandatory=$true)]
    [ValidateSet("install","upgrade","uninstall")]
    [string]$action,

    [Parameter(Mandatory=$true)]
    [ValidateSet("dev","int","prod")]
    [string]$context
)

# Default namespace
$namespace = "swissgeol-search"
$name = "swissgeol-search"
$project = "swissgeol-assets"

Write-Output "*** Prepare kubectl context '$namespace-$context' ***"
kubectl config use-context $project-$context
kubectl create namespace $namespace --dry-run=client -o yaml | kubectl apply -f - 
kubectl config set-context --current --namespace=$namespace

# Configure helm locally
# helm repo add keel https://charts.keel.sh
# helm repo update

Write-Output "*** Execute action '$action' on context '$namespace-$context' ***"
if ($action -eq 'install') {
    helm install $name helm/swissgeol-search --namespace=$namespace --values helm/swissgeol-search/values-$context.yaml --values helm/swissgeol-search/secrets-$context.yaml
} elseif ($action -eq 'upgrade') {
    helm upgrade $name helm/swissgeol-search --namespace=$namespace --values helm/swissgeol-search/values-$context.yaml --values helm/swissgeol-search/secrets-$context.yaml
} elseif ($action -eq 'uninstall') {
    helm uninstall $name --namespace=$namespace
} else {
    Write-Output "Invalid action '$action'"
}

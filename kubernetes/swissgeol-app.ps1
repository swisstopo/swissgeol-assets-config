param (
    [Parameter(Mandatory=$true)]
    [ValidateSet("assets","search")]
    [string]$app,

    [Parameter(Mandatory=$true)]
    [ValidateSet("install","upgrade","uninstall")]
    [string]$action,

    [Parameter(Mandatory=$true)]
    [ValidateSet("dev","int","prod")]
    [string]$stage,

    [Parameter(Mandatory=$true)]
    [string]$context
)

# variables
$namespace = "swissgeol-$app"
$name = "swissgeol-$app"

Write-Output "*** Prepare kubectl context '$context' ***"
kubectl config use-context $context
kubectl create namespace $namespace --dry-run=client -o yaml | kubectl apply -f - 
kubectl config set-context --current --namespace=$namespace

Write-Output "*** Execute action '$action' on context '$context' ***"
if ($action -eq 'install') {
    helm install $name helm/$name --namespace=$namespace --values helm/$name/values-$stage.yaml --values helm/$name/secrets-$stage.yaml
} elseif ($action -eq 'upgrade') {
    helm upgrade $name helm/$name --namespace=$namespace --values helm/$name/values-$stage.yaml --values helm/$name/secrets-$stage.yaml
} elseif ($action -eq 'uninstall') {
    helm uninstall $name --namespace=$namespace
} else {
    Write-Output "Invalid action '$action'"
}

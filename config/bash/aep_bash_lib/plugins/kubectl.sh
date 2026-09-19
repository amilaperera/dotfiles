# kubectl bash plugin
command -v kubectl &>/dev/null || return

# kubectl completion
source <(kubectl completion bash)

# Aliases inspired by ohmyzsh kubectl plugin
alias k='kubectl'
alias ksys='kubectl --namespace=kube-system'
alias ka='kubectl apply'
alias kaf='kubectl apply -f'
alias ksysa='kubectl --namespace=kube-system apply -f'
alias kdel='kubectl delete'
alias kdelf='kubectl delete -f'
alias kg='kubectl get'
alias kgp='kubectl get pods'
alias kgpa='kubectl get pods --all-namespaces'
alias kgpw='kgp --watch'
alias kgpww='kgp --watch --watch-only'
alias ksvc='kubectl get svc'
alias ksvca='kubectl get svc --all-namespaces'
alias kgdep='kubectl get deployment'
alias kgdepa='kubectl get deployment --all-namespaces'
alias kgsts='kubectl get statefulset'
alias kgjob='kubectl get job'
alias kgj='kubectl get jobs'
alias kgd='kubectl get ds'
alias kgno='kubectl get nodes'
alias kgns='kubectl get namespaces'
alias kgcfg='kubectl get configmap'
alias kgsec='kubectl get secret'
alias kgall='kubectl get pods,svc,deployments,statefulsets,jobs'
alias kd='kubectl describe'
alias kdp='kubectl describe pods'
alias kdsvc='kubectl describe svc'
alias kddep='kubectl describe deployment'
alias kdno='kubectl describe nodes'
alias kdl='kubectl logs'
alias kdlf='kubectl logs -f'
alias klf='kubectl logs -f'
alias kdlp='kubectl logs $1 -p'
alias ke='kubectl exec'
alias kei='kubectl exec -it'
alias ked='kubectl exec -it deployment/'
alias kep='kubectl exec -it pod/'
alias kc='kubectl config'
alias kccc='kubectl config current-context'
alias kcgc='kubectl config get-contexts'
alias kcuc='kubectl config use-context'
alias kcdc='kubectl config delete-context'
alias kcf='kubectl config --kubeconfig'
alias kctx='kubectl config use-context'
alias kr='kubectl run'
alias kri='kubectl run -it'
alias kp='kubectl port-forward'
alias ka='kubectl apply'
alias kaf='kubectl apply -f'
alias krm='kubectl delete'
alias krmf='kubectl delete -f'
alias kl='kubectl label'
alias kdpvc='kubectl describe pvc'
alias kgpvc='kubectl get pvc'
alias krpvc='kubectl delete pvc'

# --- Helpers ---
# Switch to a context
kcon() {
    kubectl config use-context "$1"
}

# Get events
kev() {
    kubectl get events --sort-by=.metadata.creationTimestamp "$@"
}

# Get events in kube-system
ksysev() {
    kubectl --namespace=kube-system get events --sort-by=.metadata.creationTimestamp "$@"
}


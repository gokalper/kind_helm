# installs helm with bash commands for easier command line integration
# curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash
kubectl --namespace kube-system create sa tiller
kubectl create clusterrolebinding tiller \
    --clusterrole cluster-admin \
    --serviceaccount=kube-system:tiller
helm init --service-account tiller
helm repo update
kubectl get deploy,svc tiller-deploy -n kube-system
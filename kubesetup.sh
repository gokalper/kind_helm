kind create cluster
export KUBECONFIG="$(kind get kubeconfig-path --name="kind")"
echo $KUBECONFIG
kubectl cluster-info
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml
kubectl create serviceaccount my-dashboard-sa && kubectl create clusterrolebinding my-dashboard-sa --clusterrole=cluster-admin --serviceaccount=default:my-dashboard-sa
kubectl get secrets | grep my-dashboard-sa-token | awk '{print $1}' | xargs kubectl describe secret | grep token: | awk '{print $2}'
# cat > dashboard-adminuser.yml << EOF
# apiVersion: v1
# kind: ServiceAccount
# metadata:
#   name: admin-user
#   namespace: kube-system
# EOF
# kubectl apply -f dashboard-adminuser.yml
# cat > admin-role-binding.yml << EOF
# apiVersion: rbac.authorization.k8s.io/v1
# kind: ClusterRoleBinding
# metadata:
#   name: admin-user
# roleRef:
#   apiGroup: rbac.authorization.k8s.io
#   kind: ClusterRole
#   name: cluster-admin
# subjects:
# - kind: ServiceAccount
#   name: admin-user
#   namespace: kube-system
# EOF
# kubectl apply -f admin-role-binding.yml
echo "http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/"
kubectl proxy

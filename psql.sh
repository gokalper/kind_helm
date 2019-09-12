brew install libpq
echo 'export PATH="/usr/local/opt/libpq/bin:$PATH"' >> ~/.bash_profile
helm install stable/postgresql

# PostgreSQL can be accessed via port 5432 on the following DNS name from within your cluster:

#     tufted-catfish-postgresql.default.svc.cluster.local - Read/Write connection
#     kubectl run tufted-catfish-postgresql-client --rm --tty -i --restart='Never' --namespace default --image docker.io/bitnami/postgresql:11.5.0-debian-9-r34 --env="PGPASSWORD=$POSTGRES_PASSWORD" --command -- psql --host tufted-catfish-postgresql -U postgres -p 5432

# To connect to your database from outside the cluster execute the following commands:

export POSTGRES_PASSWORD=$(kubectl get secret --namespace default tufted-catfish-postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)
export KUBECONFIG="$(kind get kubeconfig-path --name="kind")"
kubectl port-forward --namespace default svc/tufted-catfish-postgresql 5432:5432
PGPASSWORD="$POSTGRES_PASSWORD" psql --host 127.0.0.1 -U postgres -p 5432
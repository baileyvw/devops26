# Links to gists for creating a Kubernetes cluster with Jenkins X
# gke-jx-boot.sh: https://gist.github.com/1eff2069aa68c4aee29c35b94dd9467f
# gke-jx.sh: https://gist.github.com/86e10c8771582c4b6a5249e9c513cd18
# eks-jx-serverless.sh: https://gist.github.com/69a4cbc65d8cb122d890add5997c463b
# eks-jx.sh: https://gist.github.com/dfaf2b91819c0618faf030e6ac536eac
# aks-jx-serverless.sh: https://gist.github.com/a7cb7a28b7e84590fbb560b16a0ee98c
# aks-jx.sh: https://gist.github.com/6e01717c398a5d034ebe05b195514060
# install-serverless.sh: https://gist.github.com/f592c72486feb0fb1301778de08ba31d
# install.sh: https://gist.github.com/3dd5592dc5d582ceeb68fb3c1cc59233

ENVIRONMENT=[...]

rm -rf environment-$ENVIRONMENT-staging

GH_USER=[...]

git clone \
    https://github.com/$GH_USER/environment-$ENVIRONMENT-staging.git

cd environment-$ENVIRONMENT-staging

cat env/requirements.yaml

echo "- name: postgresql
  version: 5.0.0
  repository: https://kubernetes-charts.storage.googleapis.com" \
    | tee -a env/requirements.yaml

git add .

git commit -m "Added PostgreSQL"

git push

jx get activities \
    --filter environment-$ENVIRONMENT-staging \
    --watch

NAMESPACE=$(kubectl config view \
    --minify \
    --output 'jsonpath={..namespace}')

kubectl \
    --namespace $NAMESPACE-staging \
    get pods,services

cd ..

rm -rf environment-$ENVIRONMENT-production

git clone \
    https://github.com/$GH_USER/environment-$ENVIRONMENT-production.git

cd environment-$ENVIRONMENT-production

echo "- name: postgresql
  version: 5.0.0
  repository: https://kubernetes-charts.storage.googleapis.com" \
    | tee -a env/requirements.yaml

helm inspect values stable/postgresql

echo "postgresql:
  replication:
    enabled: true" \
    | tee -a env/values.yaml

git add .

git commit -m "Added PostgreSQL"

git push

jx get activities \
    --filter environment-$ENVIRONMENT-production \
    --watch

kubectl \
    --namespace $NAMESPACE-production \
    get pods,services

cat env/requirements.yaml \
    | sed '$d' | sed '$d' | sed '$d' \
    | tee env/requirements.yaml

git add .

git commit -m "Removed PostgreSQL"

git push

cd ../environment-$ENVIRONMENT-staging

cat env/requirements.yaml \
    | sed '$d' | sed '$d' | sed '$d' \
    | tee env/requirements.yaml

git add .

git commit -m "Removed PostgreSQL"

git push

cd ..

# If using Jenkins X Boot
kubectl get pods

# If using Jenkins X Boot
CLUSTER_NAME=[...]

# If using Jenkins X Boot
cd environment-$CLUSTER_NAME-dev

# If using Jenkins X Boot
cat env/requirements.yaml

# If using Jenkins X Boot
kubectl get ingresses

# If using Jenkins X Boot
NEXUS_ADDR=$(kubectl get ingress nexus \
    --output jsonpath="{.spec.rules[0].host}")

# If using Jenkins X Boot
open "http://$NEXUS_ADDR"

# If using Jenkins X Boot
git pull

# If using Jenkins X Boot
ls -1 env

# If using Jenkins X Boot
cat env/nexus/values.yaml

# If using Jenkins X Boot
cat env/nexus/values.yaml \
    | sed -e \
    's@enabled: true@enabled: false@g' \
    | tee env/nexus/values.yaml

# If using Jenkins X Boot
git add .

# If using Jenkins X Boot
git commit -m "Removed Nexus"

# If using Jenkins X Boot
git push

# If using Jenkins X Boot
jx get activity \
    --filter environment-$CLUSTER_NAME-dev/master \
    --watch

# If using Jenkins X Boot
kubectl get ingresses

# If using Jenkins X Boot
open "http://$NEXUS_ADDR"

# If using Jenkins X Boot
kubectl get pods

open "https://github.com/jenkins-x-apps"

jx add app jx-app-prometheus

# If using Jenkins X Boot
jx get activity \
    --filter environment-$CLUSTER_NAME-dev/master \
    --watch

kubectl get pods \
    --selector app=prometheus

kubectl get ingresses

# If NOT using EKS
LB_IP=$(kubectl --namespace kube-system \
    get service jxing-nginx-ingress-controller \
    --output jsonpath="{.status.loadBalancer.ingress[0].ip}")

# If using EKS
LB_HOST=$(kubectl --namespace kube-system \
    get service jxing-nginx-ingress-controller \
    --output jsonpath="{.status.loadBalancer.ingress[0].hostname}")

# If using EKS
export LB_IP="$(dig +short $LB_HOST \
    | tail -n 1)"

echo $LB_IP

# If using Jenkins X Boot
git pull

# If using Jenkins X Boot
echo "prometheus:
  server:
    ingress:
      enabled: true
      hosts:
      - prometheus.$LB_IP.nip.io" \
    | tee env/jx-app-prometheus/values.yaml

# If using Jenkins X Boot
git add .

# If using Jenkins X Boot
git commit -m "Prometheus Ingress"

# If using Jenkins X Boot
git push

# If using Jenkins X Boot
jx get activity \
    --filter environment-$CLUSTER_NAME-dev/master \
    --watch

# If using Jenkins X Boot
kubectl get ingresses

# If using Jenkins X Boot
open "http://prometheus.$LB_IP.nip.io"

# If using Jenkins X Boot
jx delete app jx-app-prometheus

# If NOT using Jenkins X Boot
jx delete app jx-app-prometheus \
    --namespace $NAMESPACE

# If using Jenkins X Boot
jx get activity \
    --filter environment-$CLUSTER_NAME-dev/master \
    --watch

kubectl get pods \
    --selector app=prometheus

jx add app istio-init \
    --repository https://storage.googleapis.com/istio-release/releases/1.3.2/charts/

# If using Jenkins X Boot
jx get activity \
    --filter environment-$CLUSTER_NAME-dev/master \
    --watch

kubectl get crds | grep 'istio.io'

# If using Jenkins X Boot
git pull

# If using Jenkins X Boot
cp -r env/istio-init env/istio

# If using Jenkins X Boot
cat env/istio/templates/app.yaml

# If using Jenkins X Boot
cat env/istio/templates/app.yaml \
    | sed -e 's@istio-init@istio@g' \
    | sed -e \
    's@initialize Istio CRDs@install Istio@g' \
    | tee env/istio/templates/app.yaml

# If using Jenkins X Boot
cat env/requirements.yaml

# If using Jenkins X Boot
echo "- name: istio
  repository: https://storage.googleapis.com/istio-release/releases/1.3.2/charts/
  version: 1.3.2" \
  | tee -a env/requirements.yaml

# If using Jenkins X Boot
git add .

# If using Jenkins X Boot
git commit -m "Added Istio"

# If using Jenkins X Boot
git push

# If using Jenkins X Boot
jx get activity \
    --filter environment-$CLUSTER_NAME-dev/master \
    --watch

# If using Jenkins X Boot
kubectl get pods | grep istio

jx get apps

# If using Jenkins X Boot
git pull

# If using Jenkins X Boot
jx delete app istio

# If using Jenkins X Boot
git pull

jx delete app istio-init

# If using Jenkins X Boot
cd ..

rm -rf environment-$ENVIRONMENT-staging

hub delete -y \
    $GH_USER/environment-$ENVIRONMENT-staging

rm -rf environment-$ENVIRONMENT-production

hub delete -y \
    $GH_USER/environment-$ENVIRONMENT-production
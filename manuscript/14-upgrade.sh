# Source: https://gist.github.com/00404a74924beadda4143ac26e8fbaa1

# Links to gists for creating Jenkins X cluster
# gke-jx-serverless.sh: https://gist.github.com/a04269d359685bbd00a27643b5474ace
# eks-jx-serverless.sh: https://gist.github.com/69a4cbc65d8cb122d890add5997c463b
# aks-jx-serverless.sh: https://gist.github.com/a7cb7a28b7e84590fbb560b16a0ee98c
# install-serverless.sh: https://gist.github.com/f592c72486feb0fb1301778de08ba31d

open "https://github.com/jenkins-x/jenkins-x-versions"

PLATFORM_VERSION=[...]

NAMESPACE=$(kubectl config view \
    --minify \
    --output jsonpath="{..namespace}")

cd go-demo-6

git pull

git checkout extension-model-$NAMESPACE

git merge -s ours master --no-edit

git checkout master

git merge extension-model-$NAMESPACE

git push

cd ..

cd go-demo-6

jx import --pack go --batch-mode

cd ..

jx version

jx upgrade platform --help

jx upgrade platform --batch-mode

jx version

jx get addons

jx upgrade addons

jx get addons

jx get applications

STAGING_ADDR=[...]

curl "$STAGING_ADDR/demo/hello"

LB_IP=$(kubectl \
    --namespace kube-system \
    get svc jxing-nginx-ingress-controller \
    -o jsonpath="{.status.loadBalancer.ingress[0].ip}")

echo $LB_IP

DOMAIN=$LB_IP.nip.io

DOMAIN=[...]

jx upgrade ingress \
    --cluster true \
    --domain $DOMAIN

jx get applications --env staging

STAGING_ADDR=[...]

curl "$STAGING_ADDR/demo/hello"

cd go-demo-6

jx repo --batch-mode

echo "I am too lazy to write a README" \
    | tee README.md

git add .

git commit -m "Checking webhooks"

git push

jx get activities \
    --filter go-demo-6 \
    --watch

jx get applications --env staging

NAMESPACE=$(kubectl config view \
    --minify \
    --output jsonpath="{..namespace}")

jx upgrade ingress \
    --namespaces $NAMESPACE-staging \
    --urltemplate "{{.Service}}.staging.{{.Domain}}"

jx get applications --env staging

VERSION=[...]

STAGING_ADDR=[...]

curl "$STAGING_ADDR/demo/hello"

jx promote go-demo-6 \
    --version $VERSION \
    --env production \
    --batch-mode

jx get applications --env production

jx upgrade ingress \
    --domain $DOMAIN \
    --namespaces $NAMESPACE-production \
    --urltemplate "{{.Service}}.{{.Domain}}"

jx get applications --env production

cd ..

GH_USER=[...]

ENVIRONMENT=[...]

hub delete -y \
  $GH_USER/environment-tekton-staging

hub delete -y \
  $GH_USER/environment-tekton-production

rm -rf environment-tekton-production

rm -rf ~/.jx/environments/$GH_USER/environment-tekton-*

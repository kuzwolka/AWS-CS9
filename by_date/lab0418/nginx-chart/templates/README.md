# MY HELM CHART

## Description
- This chart is for ... test. 
You need metallb on your system.

## How to Install
```bash
helm repo add myrepo1 https://kuzwolka.github.io/aws9Chart1
helm install myrelease1 myrepo1/nginx-chart

or ------------------------------------------

helm isntall myrelease1 myrepo1/nginx-chart --set replicaCount=9
```
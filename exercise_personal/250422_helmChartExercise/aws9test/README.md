### Description
- Helm chart for study

### PREREQUISITES
- MetalLB
- KEDA
- Ingress-NGINX Controller

### How to Install
```
helm repo add helmtest https://kuzwolka.github.io/aws9helm/
helm install aws9helm helmtest/aws9helm --namespace=aws9helm --create-namespace
```

### Release --set Options
```
# Every examples given are default values
# Set application's resources requests/limits
--set resources.cpuRequests=100m
--set resources.cpuLimits=300m

# Set KEDA scailing min/max replica count
--set kedaSettings.minReplicaCount=1
--set kedaSettings.maxReplicaCount=10

# Set KEDA cron/cpu utilization trigger options
--set kedaSettings.triggers.cronDesiredReplicas=3
--set kedaSettings.triggers.cpuUtilization=60
```
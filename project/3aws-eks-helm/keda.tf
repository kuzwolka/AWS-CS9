resource "helm_release" "keda" {
  name       = "keda"
  namespace  = "keda"
  repository = "https://kedacore.github.io/charts"
  chart      = "keda"
  version    = "2.13.0" # Use a version compatible with Kubernetes 1.29
  create_namespace = true

  values = [
    <<EOF
podSecurityContext:
  fsGroup: 1001
  runAsUser: 1001
  runAsGroup: 1001

securityContext:
  runAsNonRoot: true
EOF
  ]
}
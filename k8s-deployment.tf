# resource "kubectl_manifest" "deploy" {
#   depends_on = [kubectl_manifest.namespace]
#   yaml_body  = <<YAML
# apiVersion: apps/v1
# kind: Deployment
# metadata:
#   name: nginx-deploy
#   namespace: nginx
# spec:
#   replicas: 2
#   selector:
#     matchLabels:
#       app: nginx
#   template:
#     metadata:
#       labels:
#         app: nginx
#     spec:
#       containers:
#         - name: nginx
#           image: nginx
#           ports:
#             - containerPort: 80
# YAML
# }

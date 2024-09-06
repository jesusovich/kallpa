# Minio

Minio es el bucket S3 que Nextcloud usará para guardar toda la información.

## Minio Operator

Requisito para la automatización del despliegue.

URL: https://min.io/docs/minio/kubernetes/upstream/operations/install-deploy-manage/deploy-operator-helm.html

### 1. Instalar Helm Chart

Agregar previamente el label **minio-operator=true** en los nodes donde estará el operator.

```
helm repo add minio-operator https://operator.min.io
helm search repo minio-operato
helm install \
  --namespace minio-operator \
  --create-namespace \
  --set nodeSelector.minio-operator=true \
  operator minio-operator/operator
```


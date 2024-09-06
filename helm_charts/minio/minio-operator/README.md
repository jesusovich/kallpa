# Minio

Minio es el bucket S3 que Nextcloud usará para guardar toda la información.

## Minio Operator

Requisito para la automatización del despliegue.

### 1. Editar values.yaml

- Agregar previamente el label **minio-operator=true** en los nodes donde estará el operator.
- Copiar el values localmente. 
- URL: https://github.com/minio/operator/blob/v6.0.3/helm/operator/values.yaml

```
  nodeSelector:
    minio-operator: "true"
```
### 2. Instalar Helm Chart

URL: https://min.io/docs/minio/kubernetes/upstream/operations/install-deploy-manage/deploy-operator-helm.html

```
helm repo add minio-operator https://operator.min.io
helm search repo minio-operato
helm install \
  --namespace minio-operator \
  --create-namespace \
  operator minio-operator/operator
```


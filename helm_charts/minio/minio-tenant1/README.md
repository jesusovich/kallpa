# Minio Tenant1

Es el bucket de prueba para Nextcloud

## Requisitos

- Minio Operator habilitado.
- DirectPV habilitado.

## Instalación

### 1. Crear Namespace

Ya que hay que agregar previamente un secret en k3s. Crear primero el namespace.

```
kubectl create ns minio-tenant1
```
### 1. Crear Secret

En el secret se agrega por ahora lo siguiente:

- Credenciales Minio Console.
- Composición del Erasure code.

Se guarda la información en `config.env`

**IMPORTANTE** El contenido de config.env se guarda en base64 en el secret manifest. 

```
cat config.env | base64
```
Configurar el secret.

```
kubectl apply -f minio-tenant1-env-configuration.yml
```

### Values.yaml

URL: https://github.com/minio/operator/blob/v6.0.3/helm/tenant/values.yaml

Campos editados:

- tenant.name
- tenant.configuration.name
- tenant.configSecret.existingSecret
- tenant.pool.servers
- tenant.pool.volumesPerServer
- tenant.pool.size
- tenant.pool.storageClassName
- tenant.exposeServices.console
- tenant.serviceMetadata.annotations

### Helm Chart

URL: https://min.io/docs/minio/kubernetes/upstream/operations/install-deploy-manage/deploy-minio-tenant-helm.html

```
helm install \
--namespace minio-tenant1 \
--create-namespace \
--values values.yaml \
tenant1 minio-operator/tenant
```
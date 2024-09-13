# Openebs

Es similar a local-storage de k3s, solo que ese lo estamos usando en formato xfs para Minio.

Lo otro para no tener dos storage provider con la misma función, puedo mantener openebs creando otro storage class que apunte a otra ruta. Así tendríamos dos sc uno par axfs y otro para ext4. Por ahora separado.

## Instalación

```
helm repo add openebs https://openebs.github.io/charts
helm repo update
!
helm install openebs --namespace openebs openebs/openebs --create-namespace
```
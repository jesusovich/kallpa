# MariaDB Galera

Base de Datos para Nextcloud

## 1. Editar values.yaml

- URL: https://github.com/bitnami/charts/blob/main/bitnami/mariadb-galera/values.yaml

```
  nodeSelector:
    nextcloud: "true"
```
## 2. Instalar Helm Chart

URL: https://github.com/bitnami/charts/blob/main/bitnami/mariadb-galera/README.md

Verificar que el namespace de nextcloud exista previamente.

```
helm install nextcloud-db oci://registry-1.docker.io/bitnamicharts/mariadb-galera -n nextcloud -f values.yaml
```
# MariaDB Galera

Base de Datos para Nextcloud.

Por ahora no se usa, demora 11 minutos en levantar cada pod de galera. 30 minutos en total, es mucho tiempo. Toca revisar con más calma el proceso de tener un cluster de este tipo.

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
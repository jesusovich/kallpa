# Longhorn

Se usa longhorn para habilitar los volumes persistentes de los componentes de Nextcloud: MariaDB y Redis.

## Requisitos

### 1. Copiar values.yaml

URLs: 

- https://github.com/longhorn/longhorn/tree/master
- https://github.com/longhorn/longhorn/blob/master/chart/values.yaml

Crear previamente el folder longhorn.

### 2. Editar values.yaml

```
...
### Instalar Longhorn en nodos específicos.
global:
  nodeSelector:
    longhorn: "true"
...
### Instalar Longhorn en nodos específicos.
defaultSettings:
  systemManagedComponentsNodeSelector: "longhorn:true"
...
```
### 3. Agregar Labels a los nodes

Verificar los labels en ~/scripts/add-labels.sh.

Label:

```
longhorn=true
```
### 4. Instalar NFSv4 en los nodes

Esto se requiere para los PVs tipo RWX.

URL: https://longhorn.io/docs/1.7.0/deploy/install/#installing-nfsv4-client

## Instalación

### URL

https://longhorn.io/docs/1.7.0/deploy/install/install-with-helm/

### Comandos

```
helm repo add longhorn https://charts.longhorn.io
helm repo update
helm install longhorn longhorn/longhorn --namespace longhorn-system --create-namespace --version 1.7.0 -f values.yaml
```

# Longhorn

Se usa longhorn para habilitar los volumes persistentes de los componentes de Nextcloud: MariaDB y Redis.

## Requisitos

### 1. Instalar NFSv4 en los nodes

Esto se requiere para los PVs tipo RWX.

URL: https://longhorn.io/docs/1.7.1/deploy/install/#installing-nfsv4-client

## Editar Chart

Tomar como referencia: https://longhorn.io/docs/1.7.1/deploy/install/install-with-helm/

### 1. Copiar todo el repo localmente, se hará edicion de los templates.

URL: https://github.com/longhorn/longhorn/tree/master

Hacer las ediciones dentro de la carpeta longhorn

### 2. Editar values.yaml

#### Instalar Longhorn en nodos específicos.

```
global:
  nodeSelector:
    longhorn: "true"
...
defaultSettings:
  systemManagedComponentsNodeSelector: "longhorn:true"
```

#### Publicar Tailscale Apiserver y aplicar node selector.

```
service:
  ui:
    type: LoadBalancer
    labels:
      tailscale.com/proxy-class: longhorn-nodeselector
    annotations:
      tailscale.com/expose: "true"
```
### 3. Editar templates/deployment-ui.yaml

Esto se debe a que los labels y annotations no están declarados en los templates del servicio.

```
kind: Service
apiVersion: v1
metadata:
  labels:
    {{- with .Values.service.ui.labels }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  annotations:
    {{- with .Values.service.ui.annotations }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
```
## Instalación

### 1. Agregar Labels a los nodes

Verificar los labels en `~/scripts/add-labels.sh`

Label: **longhorn=true**

### 2. Aplicar tailscale proxyclass

Esto es para que el pod de Tailscale que publica el servicio caiga también en los nodos de longhorn. 

File ubicado en `local_dev/`

```
kubectl apply -f tailscale.yml
```

### 3. Instalar Helm Chart

En este caso el repo es local. La instalación se hace fuera del folder de Longhorn.

```
helm install longhorn --namespace longhorn-system --create-namespace --version 1.7.1 ./longhorn
```

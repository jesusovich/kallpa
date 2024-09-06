# Tailscale

Adicionalmente a la instalación de Tailscale en los nodos, se activa tailscale como operador en el cluster k8s. Esto sirve al momento:

- Para que el APIserver se publique con una IP del dominio de Tailscale, así mantenemos la redundancia del API Server.

## Requisitos

Importante, esto se debe hacer desde el deployer, que ya debe tener el primer kubeconfig copiado del master.

### 1. Crear el OAuth_client en Tailscale. Ya hecho. No repetir.

```
# Client ID
k7Hn42ceRw11CNTRL

# Client secret
tskey-client-k7Hn42ceRw11CNTRL-v6tKvGt9vp8S9cuaphEBq8eB5jSrr11WA
```

### 2. Editar values.yaml

#### Copiar values.yaml

URLs: 

- https://github.com/tailscale/tailscale/blob/main/cmd/k8s-operator/deploy/chart/values.yaml

Crear previamente el folder.

#### Editar values.yaml

```
# Node Selector

  nodeSelector:
    tailscale-operator: "true"

# Client ID and Secret

  oauth:
    clientId: "k7Hn42ceRw11CNTRL"
    clientSecret: "tskey-client-k7Hn42ceRw11CNTRL-v6tKvGt9vp8S9cuaphEBq8eB5jSrr11WA"

# Habilitar Apiserver

  apiServerProxyConfig:
    mode: "true"
```
#### Agregar Labels a los nodes

Verificar los labels en ~/scripts/add-labels.sh.

Label:

```
tailscale-operator=true
```

### 3. Agregar TAGs en los ACL's. Ya hecho. No repetir.

Se debe agregar el tag para el operator y el tag para el usuario cluster-admin.

```
"tagOwners": {
   "tag:k8s-operator": [],
   "tag:k8s": ["tag:k8s-operator"],
   "tag:k8s-cluster-admin": [],
}
```
### 4. Agregar el tag k8s-cluster-admin en el deployer. Ya hecho. No repetir. O hacerlo si el deployer es nuevo.

### 5. Habilitar HTTPS. Ya hecho. No repetir.

## Instalación del Operator y Apiserver

### URLs

- https://tailscale.com/kb/1236/kubernetes-operator#setup
- https://tailscale.com/kb/1437/kubernetes-operator-api-server-proxy

### Comandos

```
# Agregar Repo

helm repo add tailscale https://pkgs.tailscale.com/helmcharts
helm repo update

# Instalar helm sobre folder tailscale-operator, verificar values.yaml

helm upgrade \
  --install \
  tailscale-operator \
  tailscale/tailscale-operator \
  --namespace=tailscale \
  --create-namespace \
  --wait \
  -f values.yaml

# Crear clusterrole cluster-admin

kubectl create clusterrolebinding tailnet-cluster-admin --group="tag:k8s-cluster-admin" --clusterrole=cluster-admin

# Habilitar kubeconfig apuntando a la nueva VIP

tailscale configure kubeconfig tailscale-operator
```
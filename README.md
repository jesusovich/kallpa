# k3s

Se usa k3s como plataforma del cluster kubernetes.

## Requisitos

### 1. Instanciar las VM's 

- Deployer
- Masters
- Workers

Este paso debe ser reemplazado por la instalación de Ubuntu Server en los nodos físicos en su momento.

### 2. Tailscale

- Instalar Tailscale en todos los nodos.
- URL: https://tailscale.com/download

### 3. SSH Key

- Crear ssh key del deployer.
- Copiar el ssh key en los nodos Master/Worker.

```
# En Deployer
ssh-keygen -t rsa
cat .ssh/id_rsa.pub
# Copiar el public key.

# En Nodos
vi .ssh/authorized_keys
# Pegar el public key del Deployer.
```

## Instalación

### 1. Descargar el Repo en el Deployer

```
git clone https://github.com/k3s-io/k3s-ansible.git
```

### 2. Crear el file inventory.yml

```
cd k3s-ansible
vi inventory.yml
```
### 3. Datos de inventory.yml

#### --node-ip
- All nodes.
- Se debe poner la IP que asigna Tailscale.

#### --flannel-iface
- All nodes.
- Se debe poner la interface de Tailscale tailscale0.

#### --disable=servicelb
- Solo en servers.
- Deshabilita el service load balancer por defecto. Se utiliza MetalLB en vez de ello.

#### --disable=local-storage
- Solo en servers.
- Deshabilita el local-storage por defecto. Se utiliza Longhorn en vez de ello.

#### --tls-san
- Solo en servers.
- Hay un error en la instalación, la IP de Tailscale debe estar dentro de las IP's permitidas para TLS.

### 4. Instalar el playbook

URL: https://github.com/k3s-io/k3s-ansible/blob/master/README.md

```
ansible-playbook playbooks/site.yml -i inventory.yml
```

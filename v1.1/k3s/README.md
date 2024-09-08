# k3s

Se usa k3s como plataforma del cluster kubernetes.

## Requisitos

### 1. Instanciar las VM's 

- Deployer
- Masters
- Workers

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
git clone https://github.com/jesusovich/kallpa.git
```

> En este caso estoy copiando el contenido en el repo de Kallpa. También se dede agregar el file **inventory.yml**

> Adicionalmente, el repo kallpa ya tiene guardado el inventory.yml, verificar previamente si existe el folder k3s-ansible. En caso no existiera crearlo de la siguiente manera: 

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

### 5. Copiar kubeconfig del Master

Correr script:

```
ubuntu@k3s-deployer:~/kallpa/v1.1/scripts$ ./copy-kubeconfig.sh 
Ingresa la IP del master: 100.71.186.8
Copiando el archivo .kube/config desde el master (100.71.186.8) al deployer...
config                                                                                                                                                              100% 2953     1.2MB/s   00:00    
El archivo .kube/config ha sido copiado exitosamente.
Reemplazando la IP 127.0.0.1 por 100.71.186.8 en el archivo /home/ubuntu/.kube/config...
La IP en el archivo .kube/config ha sido actualizada exitosamente.
```
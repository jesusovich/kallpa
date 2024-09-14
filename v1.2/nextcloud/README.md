# Instalación de Nextcloud en Contabo

Para hacerlo más fácil vamos a tratarlo como un servidor monolítico. Instalación básica.

- Docker
- Tailscale
- CasaOS

## Docker

Descargar script:

```
curl -fsSL https://get.docker.com -o install-docker.sh
```

Instalar docker con el script:

```
sudo sh install-docker.sh
```

Agregar usuario al grupo docker

```
sudo usermod -aG docker ubuntu
```

Cerrar terminal y volver a abrir para reflejar el cambio.

## CasaOS

URL: https://casaos.zimaspace.com/

Install:

```
curl -fsSL https://get.casaos.io | sudo bash
```
Acceder con la URL: http://207.244.230.243

En casaOS instalar Portainer. se debe ir a App Store y hacer la instalación.

**Importante:** Cambiar el puerto a 8080, ya que el 80 será ocupado por `nginxproxymanager`.

Nueva URL con el puerto cambiado: http://207.244.230.243:8080

## Portainer

Aquí se crean los stack.

### 1. Crear red Fabric

- Ir a **local > Networks > Add network**.
- Name: `fabric`
- Subnet: `172.25.0.0/16`
- Gateway: `172.25.0.1`
- Clic en **Create the netwkork**.

## Nginx Proxy Manager

### Subir stack

- Ir a **local > Stacks > Add stack**
- Poner el nombre del stack `nginxproxymanager`.
- En **Build method** escoger **Repository**
- Habilitar Authentication. Poner las credenciales del proyecto. Username: `jesusovich`
- En Repo: `https://github.com/jesusovich/kallpa`
- En Compose path poner la ruta. Por ahora en:

```
v1.2/nextcloud/stacks/nginxproxymanager/docker-compose.yml
```

- Damos clic en **Add an environment variable**

```
key: DATA_PATH
value: /home/ubuntu
```

- Finalmente `Deploy the stack`

### Cambiar usuario

Acceder con la IP del servidor. En este caso puerto 81.

- URL: http://207.244.230.243:81

Credenciales por defecto para loguearse a nginx:

- Email: `admin@example.com`
- Password: `changeme`

Te pide cambiar las credenciales:

- Email: `invitados.pjesusovich@gmail.com`
- New Pass: **En Bitbwarden.**

### Cargar certificado Kallpa

- Ir a **SSL Certificates > Add SSL Certificate > Custom** 
- En name `kallpa`
- Luego cargar los certificados. En **Certificate Key** va `privkey.pem` y en **Certificate** va `cert.pem`.

## Pihole

### Requisitos

- Se debe dar de baja el servicio DNS en ubuntu:

URL: https://discourse.pi-hole.net/t/update-what-to-do-if-port-53-is-already-in-use/52033

Basicamente:

```
To solve that you need to edit the /etc/systemd/resolved.conf and uncomment DNSStubListener and change it to no, so it looks like this: DNSStubListener=no

After that reboot your system or restart the service with sudo systemctl restart systemd-resolved
```

### Subir stack

- Ir a **local > Stacks > Add stack**
- Poner el nombre del stack `pihole`.
- En **Build method** escoger **Repository**
- Habilitar Authentication. Poner las credenciales del proyecto. Username: `jesusovich`
- En Repo: `https://github.com/jesusovich/kallpa`
- En Compose path poner la ruta. Por ahora en:

```
v1.2/nextcloud/stacks/pihole/docker-compose.yml
```

- Damos clic en **Add an environment variable**

```
key: DATA_PATH
value: /home/ubuntu

Other Keys:
- WEBPASSWORD
```

- Finalmente `Deploy the stack`

### Acceso:

URL: http://207.244.230.243:8081/admin

### Agregar DNS a Tailscale

- En tailscale. Ir a **DNS > Add nameserver > Custom...**
- Poner la IP de la VM, localizarla en machines.
- habilitar **Override local DNS**.


## Nextcloud

### Subir stack

- Ir a **local > Stacks > Add stack**
- Poner el nombre del stack `nextcloud`.
- En **Build method** escoger **Repository**
- Habilitar Authentication. Poner las credenciales del proyecto. Username: `jesusovich`
- En Repo: `https://github.com/jesusovich/kallpa`
- En Compose path poner la ruta. Por ahora en:

```
v1.2/nextcloud/stacks/nextcloud/docker-compose.yml
```

- Damos clic en **Add an environment variable**

```
key: DATA_PATH
value: /home/ubuntu

Other Keys:
- MYSQL_USER
- MYSQL_DATABASE
- MYSQL_PASSWORD
- MYSQL_ROOT_PASSWORD
```

- Finalmente `Deploy the stack`

### Registrar dominio en Pihole

- En Pihole, ir a **Local DNS > DNS Records**
- Agregar el dominio con la IP del host

```
Domain: nextcloud.kallpa.xyz
IP address: 207.244.230.243
```

- Clic en **Add**.


### Crear Host en Nginx Proxy Manager

- Ir a **Hosts > Proxy Hosts > Add Proxy Host**
- Agregar los siguientes datos:

```
Domain Names: nextcloud.kallpa.xyz
Puerto: 80
Forward Hostname: nextcloud
Block Common Exploits: enable
Websockets Support: enable
SSL: kallpa
Habilitar todo los adicionales.
```

### Acceso a nextcloud

- Entrar a la URL: https://nextcloud.kallpa.xyz
- Por primera vez te pide crear un usuario admin.
- Credenciales en bitwarden.
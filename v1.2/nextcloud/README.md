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
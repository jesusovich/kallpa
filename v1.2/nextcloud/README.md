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

En casaOS instalar Portainer. se debe ir a App Store y hacer la instalación.

**Importante:** Cambiar el puerto a 8080, ya que el 80 será ocupado por `nginxproxymanager`.

## Portainer

Aquí se crean los stack.

### 1. Crear red Fabric

- Ir a **local > Networks > Add network**.
- Name: `fabric`
- Subnet: `172.25.0.0/16`
- Gateway: `172.25.0.1`
- Clic en **Create the netwkork**.

## Nginx Proxy Manager

### Subir stacks

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

key: `DATA_PATH`
value: `/home/ubuntu`




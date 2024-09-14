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

Aquí se crean los recursos de docker, networks, stacks, etc. es fácil ver los logs por aquí también. Protainer se instala desde CasaOS, valores por defecto.

### Crear red Fabric

- Ir a **local > Networks > Add network**.
- Name: `fabric`
- Subnet: `172.25.0.0/16`
- Gateway: `172.25.0.1`
- En **Advanced configuration** agregar label (Esto ultimo es por un error que salió al crear los recursos en casaos)

```
name: com.docker.compose.network
value: fabric
```

- Deshabilitiar **Access control**.
- Clic en **Create the netwkork**.

## Nginx Proxy Manager

### Install desde CasaOS

- Ir a **App Store**
- Buscar Nginx Proxy Manager.
- custom install.
- Modificar el bridge. Considerar bridge `fabric`.

### Cambiar usuario

Accede desde Casa OS.

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

## Registro DNS en xyz.

en xyz debemos registrar un nombre de dominio tipo A con lo siguiente:

```
nombre: nextcloud
ip: 207.244.230.243
```

Con eso obtendremos el nombre de dominio `nextcloud.kallpa.xyz`

## Nextcloud

### Docker Compose

Estábamos usando Stacks de Portainer para ello, pero mejor vamos a deployarlo directamente.



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
# Directpv

- Es un utilitario de minio para el manejo de los discos.
- Reconoce los discos locales y los agrega al sistema.
- Genera un storageclass dedicado para minio.
- URL: https://github.com/minio/directpv


## Instalación

### Install DirectPV Krew plugin

Verificar que se tenga krew previamente.

```
kubectl krew install directpv
```
### Install DirectPV in your kubernetes cluster. 

- Pendiente validar nodeSelector para el directpv controller. Debe caer en los masters.
- los directpv nodes también lo del nodeSelector, deben de caer en los workers, no en los master.

```
# Download DirectPV plugin.
release=$(curl -sfL "https://api.github.com/repos/minio/directpv/releases/latest" | awk '/tag_name/ { print substr($2, 3, length($2)-4) }')
curl -fLo kubectl-directpv https://github.com/minio/directpv/releases/download/v${release}/kubectl-directpv_${release}_linux_arm64

# Make the binary executable.
chmod a+x kubectl-directpv
```

```
kubectl directpv install
```

### Get information of the installation

**Importante!!** Esperar que todos los pods estén en Running.

```
kubectl directpv info
```

### Add drives

Validar previamente que los discos no estén montados en los Workers.
Borrar alguna entrada en /etc/fstab relacionada al disco.

```
# Probe and save drive information to drives.yaml file.
kubectl directpv discover

# Initialize selected drives
kubectl directpv init drives.yaml
```
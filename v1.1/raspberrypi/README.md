# RaspberryPi


## 1. Cargar SO Ubuntu Server en microSD

### Guía de Instalación

URL: https://ubuntu.com/tutorials/how-to-install-ubuntu-on-your-raspberry-pi#1-overview

### Consideraciones

- Utilizar microSD (Por ahora) Se podría usar un microSD más barato y de menor capacidad. Esto debido a que para etcd de k3s se requiere ocupar el disco NVMe. Lo que haremos más adelante es una partición del disco.

- Inicialmente para el user y pass utilizar ubuntu/ubuntu

- Configuraciones de red. Lo más fácil inicialmente es habilitar la red Wifi.

- Habilitar acceso remoto via SSH.

## 2. Armado Case Argon NEO 5 NVMe

### Guía de Instalación

- https://www.youtube.com/watch?v=5Su4u4G-VIk&ab_channel=ExplainingComputers
- https://www.youtube.com/watch?v=J65eqaYhBZM&t=314s&ab_channel=DanieloTech

### Consideracioners

- El armado considera que el microSD ya está preparado. Esto debido a que al cerrar el Case el microSD se queda dentro, no hay forma de manipularlo.

- Al final de la guía se sugiere correr unos scripts para que el SO funcione correctamente con el Case. Sin embargo, estos scripts no están preparados para Ubuntu Server. En el siguiente apartado se agregan los comandos necesarios.

## 3. Acceso a Ubuntu Server

### Entorno de red LAN

- La IP de Raspberrypi se asigna via DHCP, para acceder remotamente es necesario ubicar la IP del equipo. Se puede utilizar aplicaciones de telefono como Fing para hacer un scaneo de la red local. Una vez ubicada la IP probar acceso SSH con las credenciales del apartado anterior. Por ejemplo:

```
ssh ubuntu@192.168.2.16
```

### Cambio de IP a estático

- Ubicada la IP debemos de cambiar el netplan del equipo de tal forma que ya no se conecte via WIFI, si no que utilice el puerto de red físico con una IP estática. La configuración es el file `netplan`.

#### Editar Netplan
```
sudo vi /etc/netplan/50-cloud-init.yaml
```

#### Ejemplo de Netplan
```
network:
    ethernets:
        eth0:
            dhcp4: false
            addresses:
            - 192.168.2.240/24
            routes:
            - to: 0.0.0.0/0
              via: 192.168.2.1
            nameservers:
                addresses: [192.168.2.1]
    version: 2
```

#### Aplicar cambios
```
sudo netplan apply
```
Aquí cambió la IP, abrir otra terminal y acceder con la nueva IP.


## 4. Comandos Argon NEO 5 NVMe

### EEPROM config

```
sudo apt-get update
sudo apt-get upgrade
!
sudo rpi-eeprom-update
sudo rpi-eeprom-config -e
```
Se abre un editor en nano. Los datos a editar son:
```
[all]
BOOT_UART=1
WAKE_ON_GPIO=0
POWER_OFF_ON_HALT=1
BOOT_ORDER=0xf416
PCIE_PROBE=1
```
Luego un reboot y listo.

### NVMe M.2 Config

```
sudo vi /boot/firmware/config.txt
```
Agregar las siguientes lineas al final:
```
usb_max_current_enable=1
dtparam=nvme
dtparam=pciex1
dtparam=pciex1_gen=3
```
Luego un reboot y listo.

## 5. Particionado de discos

### Ubicación

Consultar los discos disponibles, debería salir algo como esto:

```
ubuntu@kallpa-master1:~$ lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
loop0         7:0    0  33.7M  1 loop /snap/snapd/21761
mmcblk0     179:0    0 119.1G  0 disk 
├─mmcblk0p1 179:1    0   512M  0 part /boot/firmware
└─mmcblk0p2 179:2    0 118.6G  0 part /
nvme0n1     259:0    0 931.5G  0 disk
```
En este caso `mmcblk0` es el microSD y `nvme0n1` es el disco adicional NVMe.

### Distribución

Vamos a particionar el disco de tal formna con lo siguiente:

1. Montaje k3s 120GB.
2. Montaje Longhorn 100GB.
2. Montaje Minio Restante.

### Comandos

```
ubuntu@kallpa-master1:~$ sudo fdisk /dev/nvme0n1

```
Ahora los discos deberían verse así:

```
ubuntu@kallpa-master1:~$ lsblk

```
## 6. Montaje para k3s

### Ubicación

- k3s guarda los archivos de configuración, data y backend etcd en `/var/lib/rancher`. Usaremos la partición `nvme0n1p1`para ello.
- Loghorn utiliza `/var/lib/longhorn`. Usaremos la partición `nvme0n1p2`para ello.
- k3s local-path guarda los PV's en `/var/lib/rancher/storage`. Usaremos la partición `nvme0n1p3`para ello.

### Montaje

#### Formato de disco

```
sudo mkfs.ext4 /dev/nvme0n1p1
sudo mkfs.ext4 /dev/nvme0n1p2
sudo mkfs.xfs /dev/nvme0n1p3
```

#### Crear Label

```
sudo e2label /dev/nvme0n1p1 K3S_SYSTEM
sudo e2label /dev/nvme0n1p2 LONGHORN
sudo xfs_admin -L "K3S_VOLUMES" /dev/nvme0n1p3
```

#### Editar /etc/fstab

```
sudo vi /etc/fstab
```

Agregar esta linea:

```
LABEL=K3S_VOLUMES   /var/lib/rancher/k3s/storage    xfs    defaults,nofail 0       2
LABEL=K3S_SYSTEM   /var/lib/rancher    ext4    defaults,nofail 0       2
LABEL=LONGHORN   /var/lib/longhorn    ext4    defaults,nofail 0       2
```

Luego un reboot

## 7 Sudoers para ubuntu

```
echo "ubuntu ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/ubuntu
```
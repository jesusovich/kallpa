#!/bin/bash

# Definir la IP o nombre de host del k3s-master1
MASTER_NODE="k3s-master1"

# Usuario SSH para conectarse al master (ajústalo si es diferente)
SSH_USER="ubuntu"

# Ruta al archivo .kube/config en el master
REMOTE_KUBECONFIG="/home/$SSH_USER/.kube/config"

# Ruta destino del kubeconfig en la máquina local
LOCAL_KUBECONFIG="$HOME/.kube/config"

# Conectarse por SSH y copiar el kubeconfig al deployer
echo "Conectando a $MASTER_NODE y copiando el kubeconfig..."

# Crear el directorio ~/.kube si no existe
mkdir -p "$HOME/.kube"

# Copiar el archivo kubeconfig desde el master
scp "$SSH_USER@$MASTER_NODE:$REMOTE_KUBECONFIG" "$LOCAL_KUBECONFIG"

if [ $? -eq 0 ]; then
  echo "El kubeconfig se ha copiado exitosamente a $LOCAL_KUBECONFIG."
else
  echo "Hubo un error al copiar el kubeconfig."
  exit 1
fi

# Opcional: configurar los permisos adecuados para el kubeconfig
chmod 600 "$LOCAL_KUBECONFIG"

echo "Proceso completado."

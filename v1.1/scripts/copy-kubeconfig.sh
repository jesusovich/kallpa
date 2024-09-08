#!/bin/bash

# Solicita la IP del master como input
read -p "Ingresa la IP del master: " MASTER_IP

# Define la ruta del archivo .kube/config en el master y en el deployer
MASTER_KUBECONFIG="/root/.kube/config"  # Puedes cambiar esta ruta si es diferente
DEPLOYER_KUBECONFIG="$HOME/.kube/config"

# Verifica si la carpeta .kube existe en el deployer, de lo contrario la crea
if [ ! -d "$HOME/.kube" ]; then
    echo "Creando la carpeta .kube en $HOME..."
    mkdir -p "$HOME/.kube"
fi

# Usa scp para copiar el archivo .kube/config desde el master al deployer
echo "Copiando el archivo .kube/config desde el master ($MASTER_IP) al deployer..."
scp ubuntu@$MASTER_IP:$MASTER_KUBECONFIG $DEPLOYER_KUBECONFIG

# Verifica si la copia fue exitosa
if [ $? -eq 0 ]; then
    echo "El archivo .kube/config ha sido copiado exitosamente."
else
    echo "Error: No se pudo copiar el archivo .kube/config. Verifica la conexión y las rutas."
    exit 1
fi

# Reemplaza la IP 127.0.0.1 en el archivo kubeconfig con la IP proporcionada
echo "Reemplazando la IP 127.0.0.1 por $MASTER_IP en el archivo $DEPLOYER_KUBECONFIG..."
sed -i "s/127.0.0.1/$MASTER_IP/g" $DEPLOYER_KUBECONFIG

# Verifica si el reemplazo fue exitoso
if [ $? -eq 0 ]; then
    echo "La IP en el archivo .kube/config ha sido actualizada exitosamente."
else
    echo "Error: No se pudo actualizar la IP en el archivo .kube/config."
fi
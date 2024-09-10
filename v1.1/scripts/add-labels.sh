#!/bin/bash

# Array de nodos
# NODES=("kallpa-master1" "kallpa-master2" "vmi2136897.contaboserver.net")
NODES=("kallpa-master1" "kallpa-master2" "kallpa-master3")

# Labels a aplicar
LABELS=("nextcloud=true" "longhorn=true" "tailscale-operator=true" "minio-operator=true")

# Iterar sobre cada nodo
for NODE in "${NODES[@]}"; do
  echo "Aplicando labels al nodo $NODE..."
  
  # Iterar sobre cada label y aplicarlo al nodo
  for LABEL in "${LABELS[@]}"; do
    kubectl label node "$NODE" "$LABEL" --overwrite
  done
  
  echo "Labels aplicados exitosamente a $NODE."
done

echo "Proceso completado para todos los nodos."

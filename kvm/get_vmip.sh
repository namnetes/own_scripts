#!/bin/bash

# Nom de la VM
VM_NAME="ELK"

# Vérifier si la VM est active
VM_STATE=$(virsh list --all | grep "$VM_NAME" | awk '{print $3}')

if [ "$VM_STATE" != "running" ]; then
    echo "La VM $VM_NAME n'est pas active. Démarrage en cours..."
    virsh start "$VM_NAME"
    sleep 5  # Attendre quelques secondes pour que la VM démarre
fi

# Récupérer l'IP de la VM
VM_IP=$(virsh domifaddr "$VM_NAME" | grep -oP '(\d{1,3}\.){3}\d{1,3}')

if [ -z "$VM_IP" ]; then
    echo "Impossible de récupérer l'IP de la VM $VM_NAME"
    exit 1
else
    echo "IP de la VM $VM_NAME : $VM_IP"
fi

# Connexion SSH à la VM
echo "Connexion SSH à la VM $VM_NAME ($VM_IP)..."

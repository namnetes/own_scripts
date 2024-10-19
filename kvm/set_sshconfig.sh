#!/bin/bash

VM_NAME="ELK"
VM_USER="galan"

VM_STATE=$(virsh list --all | grep "$VM_NAME" | awk '{print $3}')

if [ "$VM_STATE" != "running" ]; then
    echo "La VM $VM_NAME n'est pas active. Démarrage en cours..."
    virsh start "$VM_NAME"
    sleep 5
fi

VM_IP=$(virsh domifaddr "$VM_NAME" | grep -oP '(\d{1,3}\.){3}\d{1,3}')

if [ -z "$VM_IP" ]; then
    echo "Impossible de récupérer l'IP de la VM $VM_NAME"
    exit 1
else
    echo "IP de la VM $VM_NAME : $VM_IP"
fi

SSH_CONFIG_PATH="$HOME/.ssh/config"
#sed -i "/^Host elk-vm$/,/^Host / s/^\( *HostName *\)\([0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.\)\(.*\)/\1$VM_IP\2/" $SSH_CONFIG_PATH
#sed -i "
  # Trouver la section qui commence par 'Host elk-vm' et se termine par une autre ligne Host'
#  /^Host elk-vm$/,/^Host / {
    # Rechercher la ligne qui commence par 'HostName' et modifier son adresse IP
#    s/^\( *HostName *\)\([0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.\)\(.*\)/\1$VM_IP\2/
#  }
#" "$SSH_CONFIG_PATH"

sed -i "
# Trouver la section qui commence par 'Host elk-vm' et se termine par une autre ligne Host'
/^Host elk-vm$/,/^Host / {
  # Rechercher la ligne qui commence par 'HostName' et modifier son adresse IP
  s/^\( *HostName *\)\([0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.\)\(.*\)/\1$VM_IP\2/
  # Rechercher la ligne qui commence par 'User' et modifier le nom d'utilisateur
  s/^\( *User *\)\(ton_utilisateur\)\(.*\)/\1$VM_USER/
}
" "$SSH_CONFIG_PATH"


echo "Connexion SSH à la VM $VM_NAME ($VM_IP)..."

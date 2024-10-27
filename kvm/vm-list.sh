#!/bin/bash

#==============================================================================
# Script Name    : list_vms.sh
# Description    : This script lists all existing virtual machines along 
#                  with their current status.
# Author         : Alan MARCHAND
#==============================================================================

# Vérifie si virsh est installé
if ! command -v virsh &> /dev/null; then
    echo "Error: virsh is not installed. Please install it first."
    exit 1
fi

# Liste toutes les VMs et leur état
echo "Listing all existing virtual machines and their status..."
echo "----------------------------------------------------------"
printf "%-30s %-10s\n" "VM Name" "Status"
echo "----------------------------------------------------------"

# Récupère la liste des VMs avec leur état
virsh list --all --name | while read -r vm_name; do
    vm_state=$(virsh domstate "$vm_name" 2>/dev/null)
    printf "%-30s %-10s\n" "$vm_name" "$vm_state"
done

echo "----------------------------------------------------------"

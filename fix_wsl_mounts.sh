#!/bin/bash -x
# Fixes broken /mnt/* mount points in WSL2 after Windows sleep/hibernation

echo "🔍 Scanning for broken /mnt/* mounts..."

# Liste les points de montage invalides (ls renvoie d????????? quand cassé)
broken_disks=$(ls -l /mnt 2>/dev/null | grep '^d\?[-?]\{10\}' | awk '{print $NF}' | grep -E '^[a-z]$')

if [ -z "$broken_disks" ]; then
    echo "✅ No broken mounts found under /mnt"
    exit 0
fi

for disk in $broken_disks; do
    mount_point="/mnt/$disk"
    echo "⚠️  Fixing /mnt/$disk..."

    # Essaye d'abord de démonter proprement
    sudo umount -l "$mount_point" 2>/dev/null

    # Remonte via drvfs (accès aux disques Windows)
    if sudo mount -t drvfs "${disk^^}:" "$mount_point"; then
        echo "✅ /mnt/$disk remounted successfully"
    else
        echo "❌ Failed to remount /mnt/$disk"
    fi
done

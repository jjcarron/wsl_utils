#!/bin/bash

echo "🔁 Cleaning and remounting /mnt/[a-z] drives..."

for letter in {c..z}; do
    mountpoint="/mnt/$letter"
    echo "👉 Processing $mountpoint"

    # Répéter plusieurs umount pour virer les montages empilés (fantômes compris)
    for i in {1..5}; do
        # if mountpoint -q "$mountpoint"; then
            # echo "   🧹 Attempt $i: unmounting $mountpoint"
            sudo umount -l "$mountpoint" 2>/dev/null
        # fi
    done

    # Supprimer le dossier s'il est vide ou cassé
    if [ -d "$mountpoint" ]; then
        sudo rmdir "$mountpoint" 2>/dev/null
    fi

    # Recréer le point de montage proprement
    sudo mkdir -p "$mountpoint"
    sudo mount -t drvfs "${letter^^}:" "$mountpoint" 2>/dev/null

    # Vérifier le résultat
    if ls "$mountpoint" >/dev/null 2>&1; then
        echo "   ✅ Mounted /mnt/$letter"
    else
        echo "   ❌ Failed to mount /mnt/$letter"
    fi
done

echo "✅ Done."


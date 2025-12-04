#!/bin/basha -x

echo "🔍 Scanning for broken /mnt/[a-z] mount points..."

for letter in {c..z}; do
    mountpoint="/mnt/$letter"

    # On ignore s'il n'existe pas
    [ -d "$mountpoint" ] || continue

    # Vérifie si ls échoue avec "Input/output error"
    ls "$mountpoint" >/dev/null 2>&1
    if [ $? -eq 5 ]; then
        echo "⚠️  Detected I/O error on $mountpoint — fixing..."

        # Force plusieurs umounts pour nettoyer tous les montages empilés
        for i in {1..5}; do
            sudo umount -l "$mountpoint" 2>/dev/null
        done

        # Supprimer le dossier de montage s'il reste
        sudo rmdir "$mountpoint" 2>/dev/null

        # Recréer et remonter
        sudo mkdir -p "$mountpoint"
        sudo mount -t drvfs "${letter^^}:" "$mountpoint" 2>/dev/null

        # Vérifie si le montage est réparé
        if ls "$mountpoint" >/dev/null 2>&1; then
            echo "   ✅ Repaired /mnt/$letter"
        else
            echo "   ❌ Still broken /mnt/$letter"
        fi
    fi
done

echo "✅ Scan complete."


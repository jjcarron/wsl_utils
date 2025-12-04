#!/bin/bash -x

echo "⚙️  Forcing unmount of all drvfs entries..."
sudo umount -a -t drvfs 2>/dev/null

echo "🔁 Trying to remount all known Windows drives..."

# Lettres de A à Z
for drive in {c..z}; do
    mountpoint="/mnt/$drive"

    # On recrée le dossier au besoin
    sudo mkdir -p "$mountpoint"

    # On tente un montage (silencieux si ça échoue)
    sudo mount -t drvfs "${drive^^}:" "$mountpoint" 2>/dev/null

    # Vérifie si on peut maintenant y accéder
    if ls "$mountpoint" >/dev/null 2>&1; then
        echo "✅ Drive $drive: mounted"
    else
        echo "❌ Drive $drive: failed or not present"
    fi
done

echo "✅ Done."


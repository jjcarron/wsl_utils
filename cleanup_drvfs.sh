#!/bin/bash

echo "🔧 Cleaning up corrupted drvfs mounts..."

# On extrait les montages anormaux (/mnt/x avec path=*:\\134)
grep 'drvfs;path=.*\\\\134' /proc/mounts | while read -r line; do
    mountpoint=$(echo "$line" | awk '{print $2}')
    echo "⚠️  Unmounting corrupted drvfs mount at $mountpoint"
    sudo umount -l "$mountpoint"
done

echo "🔁 Remounting standard drives..."

# On remonte proprement les lettres C à Z
for drive in {c..z}; do
    mp="/mnt/$drive"
    sudo mkdir -p "$mp"
    sudo mount -t drvfs "${drive^^}:" "$mp" 2>/dev/null
    ls "$mp" >/dev/null 2>&1 && echo "✅ $drive mounted" || echo "❌ $drive failed"
done

echo "✅ Done."


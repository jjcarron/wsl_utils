#!/bin/bash

echo "🧹 Cleaning up broken drvfs mounts with \\134 suffix..."

grep 'drvfs;path=.*\\\\134' /proc/mounts | while read -r line; do
    mp=$(echo "$line" | awk '{print $2}')
    echo "⚠️  Unmounting $mp (corrupted drvfs entry)"
    sudo umount -l "$mp"
done

echo "✅ Cleanup complete."


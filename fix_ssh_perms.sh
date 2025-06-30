#!/bin/bash

echo "🔧 Fixing permissions in ~/.ssh"

chmod 700 ~/.ssh

for file in ~/.ssh/*; do
  filename=$(basename "$file")

  # Clé privée (nom sans extension .pub ou .ppk)
  if [[ ! "$filename" =~ \.pub$ && ! "$filename" =~ \.ppk$ ]]; then
    if grep -q "BEGIN" -- "$file" 2>/dev/null || [[ "$filename" =~ ^id_ ]]; then
      echo "🔒 Clé privée détectée : $filename"
      chmod 600 "$file"
      continue
    fi
  fi

  # Clé publique
  if [[ "$filename" =~ \.pub$ ]] || grep -qE "^ssh-(rsa|ed25519)" -- "$file" 2>/dev/null; then
    echo "🔑 Clé publique détectée : $filename"
    chmod 644 "$file"
    continue
  fi

  echo "❔ Autre fichier : $filename"
  chmod 644 "$file"
done

echo "✅ Permissions corrigées."


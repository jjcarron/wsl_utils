  #!/bin/bash
  set -euo pipefail

  LOG="$HOME/wsl_utils/start_pg_tunnel.log"
  SSH_KEY="$HOME/.ssh/id_ed25519"

  # évite les doublons
  if pgrep -f "autossh.*15432:localhost:5432" >/dev/null 2>&1; then
    echo "$(date) tunnel déjà actif" >>"$LOG"
    exit 0
  fi

  exec >>"$LOG" 2>&1
  echo "=== $(date) ==="

  AUTOSSH_GATETIME=0 AUTOSSH_PORT=0 \
  autossh -M 0 -N \
    -i "$SSH_KEY" \
    -o BatchMode=yes \
    -o ExitOnForwardFailure=yes \
    -o ServerAliveInterval=30 -o ServerAliveCountMax=3 \
    -o StrictHostKeyChecking=accept-new \
    -o UserKnownHostsFile="$HOME/.ssh/known_hosts" \
    -L 15432:localhost:5432 jjcarron@pg.jp2s.ch &
  AUTOSSH_PID=$!
  sleep 1
  SSH_PID=$(pgrep -f "ssh.*15432:localhost:5432" | head -n1)
  echo "autossh pid ${AUTOSSH_PID:-?}, ssh pid ${SSH_PID:-unknown}" 

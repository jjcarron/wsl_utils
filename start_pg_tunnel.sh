  #!/bin/bash
  set -e
  if pgrep -f "autossh.*15432:localhost:5432" >/dev/null 2>&1; then exit 0; fi
  export AUTOSSH_GATETIME=0 AUTOSSH_PORT=0
  nohup autossh -M 0 -o ServerAliveInterval=30 -o ServerAliveCountMax=3 -N -L 15432:localhost:5432 jjcarron@pg.jp2s.ch >/dev/null 2>&1 &


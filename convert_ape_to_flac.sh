#! /bin/bash -x

find /mnt/l/Music/ -type f -iname "*.ape" -print0 | while IFS= read -r -d '' apefile; do
  flacfile="${apefile%.*}.flac"

  if [[ -f "$flacfile" ]]; then
    echo "❌ Déjà converti : $flacfile — on saute."
    continue
  fi

  echo "✅ Conversion : $apefile → $flacfile"
  ffmpeg -hide_banner -nostdin -v error -i "$apefile" -map 0:a -c:a flac "$flacfile"
done


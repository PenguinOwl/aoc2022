#! /bin/bash
while true; do
inotifywait -e close_write -m $PWD |
while read -r directory events filename; do
  if [ "$filename" = "$1" ]; then
    echo "---------------"
    echo "running $1"
    crystal run $PWD/$1
  fi
done
done

#!/usr/bin/env bash

if [[ -n "$1" ]] ; then
  FILE="$1"
  case "$FILE" in
    *.tar )     shift && tar cf "$FILE" "$@"  ;;
    *.tar.bz2 ) shift && tar cjf "$FILE" "$@" ;;
    *.tar.gz )  shift && tar czf "$FILE" "$@" ;;
    *.tgz )     shift && tar czf "$FILE" "$@" ;;
    *.zip )     shift && zip -r "$FILE" "$@"  ;;
    *.7z )      shift && 7z a "$FILE" "$@"    ;;
    *)          echo "Unsupported extension: $FILE" && exit 1 ;;
  esac
else
  echo "Usage: compress <fileName>.<ext> ...<file>"
fi

    

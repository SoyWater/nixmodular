#!/usr/bin/env bash

# Check if an argument was provided to satisfy 'set -u' (nounset)
if [ -z "${1:-}" ]; then
    echo "Usage: extract <filename>"
    exit 1
fi

if [ -f "$1" ] ; then
    filename=$(basename "$1")
    foldername=""

    case "$1" in
        *.tar.bz2)
            foldername="${filename%.tar.bz2}"
            mkdir -p "$foldername"
            tar xjvf "$1" -C "$foldername"
            ;;
        *.tar.gz)
            foldername="${filename%.tar.gz}"
            mkdir -p "$foldername"
            tar xzvf "$1" -C "$foldername"
            ;;
        *.tar.xz)
            foldername="${filename%.tar.xz}"
            mkdir -p "$foldername"
            tar xJvf "$1" -C "$foldername"
            ;;
        *.tar)
            foldername="${filename%.tar}"
            mkdir -p "$foldername"
            tar xvf "$1" -C "$foldername"
            ;;
        *.tbz2)
            foldername="${filename%.tbz2}"
            mkdir -p "$foldername"
            tar xjf "$1" -C "$foldername"
            ;;
        *.tgz)
            foldername="${filename%.tgz}"
            mkdir -p "$foldername"
            tar xzf "$1" -C "$foldername"
            ;;
        *.zip)
            foldername="${filename%.zip}"
            mkdir -p "$foldername"
            unzip "$1" -d "$foldername"
            ;;
        *.7z)
            foldername="${filename%.7z}"
            # 7z uses -o without a space
            7z x "$1" -o"$foldername"
            ;;
        *.rar)
            foldername="${filename%.rar}"
            mkdir -p "$foldername"
            unrar x "$1" "$foldername/"
            ;;
        *.bz2)
            foldername="${filename%.bz2}"
            mkdir -p "$foldername"
            # bzip2 is a file compressor, so we stream it to a file inside the new dir
            bzip2 -dc "$1" > "$foldername/$foldername"
            ;;
        *.gz)
            foldername="${filename%.gz}"
            mkdir -p "$foldername"
            gunzip -c "$1" > "$foldername/$foldername"
            ;;
        *.Z)
            foldername="${filename%.Z}"
            mkdir -p "$foldername"
            uncompress -c "$1" > "$foldername/$foldername"
            ;;
        *)
            echo "'$1' cannot be extracted via extract()"
            ;;
    esac
else
    echo "'$1' is not a valid file"
fi

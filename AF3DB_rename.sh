#!/usr/bin/env bash

set -euo pipefail

DIR="$1"

mapfile -t files < <(ls "$DIR"/*.part_*.fa "$DIR"/*.part_*.fasta 2>/dev/null)

total=${#files[@]}

if [[ $total -eq 0 ]]; then
    echo "No matching files found in $DIR"
    exit 1
fi

total_padded=$(printf "%05d" "$total")


max_part=0
for f in "${files[@]}"; do
    base=$(basename "$f")
    if [[ "$base" =~ part_([0-9]+) ]]; then
        n="${BASH_REMATCH[1]}"
        (( 10#$n > 10#$max_part )) && max_part="$n"
    fi
done

for f in "${files[@]}"; do
    base=$(basename "$f")
    dir=$(dirname "$f")

    if [[ "$base" =~ part_([0-9]+) ]]; then
        idx="${BASH_REMATCH[1]}"
    else
        echo "Skipping (no part number): $base"
        continue
    fi


    if [[ $((10#$idx)) -eq $((10#$max_part)) ]]; then
        idx_padded="00000"
    else
        idx_padded=$(printf "%05d" "$((10#$idx))")
    fi

    ext="${base##*.}"

    prefix="${base%.*}"
    prefix="${prefix%.part_${idx}}"

    new_name="${prefix}.${ext}-${idx_padded}-of-${total_padded}"
    new_path="${dir}/${new_name}"

    echo "Renaming: $base -> $new_name"
    mv "$f" "$new_path"
done


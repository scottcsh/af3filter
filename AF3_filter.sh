#!/bin/bash

OUTPUT="results.csv"
DIR=""
IPTM_THRESHOLD=""
PTM_THRESHOLD=""
SCORE_THRESHOLD=""
PAE_THRESHOLD=""
MAX_OUTPUT=""

# Option parsing
while [[ $# -gt 0 ]]; do
  case $1 in
    --dir) DIR="$2"; shift 2 ;;
    --out) OUTPUT="$2"; shift 2 ;;
    --iptm) IPTM_THRESHOLD="$2"; shift 2 ;;
    --ptm) PTM_THRESHOLD="$2"; shift 2 ;;
    --score) SCORE_THRESHOLD="$2"; shift 2 ;;
    --pae) PAE_THRESHOLD="$2"; shift 2 ;;
    --max_output) MAX_OUTPUT="$2"; shift 2 ;;
    --help)
      echo "Usage: $0 --dir <json directory> [--out <output filename>] [--iptm <threshold>] [--ptm <threshold>] [--score <threshold>] [--pae <threshold>] [--max_output <N>]"
      echo ""
      echo "Options:"
      echo "  --dir         Root directory containing JSON files (required)"
      echo "  --out         Output CSV filename (optional, default: results.csv)"
      echo "  --iptm        Minimum iptm value (optional)"
      echo "  --ptm         Minimum ptm value (optional)"
      echo "  --score       Minimum ranking_score value (optional)"
      echo "  --pae         Maximum allowed chain_pair_pae_min[0][1] value (optional)"
      echo "  --max_output  Limit output to top N entries sorted by average(iptm, ptm, score)"
      echo "  --help        Show this help message"
      exit 0
      ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

if [ -z "$DIR" ]; then
  echo "You must specify a directory."
  exit 1
fi

TMPFILE=$(mktemp)

echo " --------------------------------- "
echo "|Filter AlphaFold 3 Server Outputs|"
echo "|Last modified 2026.01.20.  v1.0.0|"
echo "|GIST jinlab       Choi, Seung Hun|"
echo " --------------------------------- "
echo "Now processing..."
echo " --------------------------------- "


# Collect data
find "$DIR" -type f -name "*summary_confidences*.json" | while read FILE; do
    iptm=$(jq '.iptm' "$FILE")
    ptm=$(jq '.ptm' "$FILE")
    ranking_score=$(jq '.ranking_score' "$FILE")
    pae_second=$(jq '.chain_pair_pae_min[0][1]' "$FILE")

    pass=true
    if [ -n "$IPTM_THRESHOLD" ] && (( $(echo "$iptm < $IPTM_THRESHOLD" | bc -l) )); then pass=false; fi
    if [ -n "$PTM_THRESHOLD" ] && (( $(echo "$ptm < $PTM_THRESHOLD" | bc -l) )); then pass=false; fi
    if [ -n "$SCORE_THRESHOLD" ] && (( $(echo "$ranking_score < $SCORE_THRESHOLD" | bc -l) )); then pass=false; fi
    if [ -n "$PAE_THRESHOLD" ] && (( $(echo "$pae_second >= $PAE_THRESHOLD" | bc -l) )); then pass=false; fi

    if [ "$pass" = true ]; then
        avg=$(echo "($iptm + $ptm + $ranking_score)/3" | bc -l)
        # keep avg only for sorting, not in final output
        echo "$(basename "$FILE"),$iptm,$ptm,$ranking_score,$pae_second,$avg" >> "$TMPFILE"
    fi
done

# Sort by average desc, limit, then sort by filename asc
{
  echo "filename,iptm,ptm,ranking_score,pae_second"
  if [ -n "$MAX_OUTPUT" ]; then
    sort -t',' -k6 -nr "$TMPFILE" | head -n "$MAX_OUTPUT" | sort -t',' -k1,1 | cut -d',' -f1-5
  else
    sort -t',' -k6 -nr "$TMPFILE" | sort -t',' -k1,1 | cut -d',' -f1-5
  fi
} | column -t -s, > "$OUTPUT"

rm "$TMPFILE"

echo "Results saved to $OUTPUT"
echo " --------------------------------- "



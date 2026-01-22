#!/bin/bash

# Usage: ./fa_to_json.sh --dir /path/to/directory --fa /path/to/file.fa

# Parse options
while [[ $# -gt 0 ]]; do
  case $1 in
    --dir)
      DIR="$2"
      shift 2
      ;;
    --fa)
      FA_FILE="$2"
      shift 2
      ;;
    *)
      echo "Usage: $0 --dir <directory> --fa <file.fa>"
      exit 1
      ;;
  esac
done

# Check directory
if [[ -z "$DIR" ]]; then
  echo "Error: --dir option is required."
  exit 1
fi

if [[ ! -d "$DIR" ]]; then
  echo "Error: $DIR is not a valid directory."
  exit 1
fi

# Optional FA file check
if [[ -n "$FA_FILE" && ! -f "$FA_FILE" ]]; then
  echo "Error: $FA_FILE is not a valid file."
  exit 1
fi

extra_seq=""
if [[ -n "$FA_FILE" ]]; then
  seq=$(grep -v '^>' "$FA_FILE" | tr -d '\r\n')
  extra_seq=$(cat <<EOF
      {
        "proteinChain": {
          "sequence": "$seq",
          "count": 1
        }
      }
EOF
)
fi

# Process all .fa files in the directory
for file in "$DIR"/*.fa; do
  if [[ -f "$file" ]]; then
    base=$(basename "$file" .fa)
    out="$DIR/$base.json"

    echo "[" > "$out"
	job=1
	awk -v extra="$extra_seq" -v base="$base" '
	/sample=/ {
	  getline;
	  printf "  {\n" \
		 "    \"name\": \"%s_job_%d\",\n" \
		 "    \"modelSeeds\": [],\n" \
		 "    \"sequences\": [\n" \
		 "      {\n" \
		 "        \"proteinChain\": {\n" \
		 "          \"sequence\": \"%s\",\n" \
		 "          \"count\": 1\n" \
		 "        }\n" \
		 "      }%s\n" \
		 "    ]\n" \
		 "  },\n",
		 base, ++job, $0, (extra=="" ? "" : ",\n" extra)
	}' "$file" | sed '$ s/},/}/' >> "$out"
	echo "]" >> "$out"
  fi
done

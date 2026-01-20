# af3filter
Filter AlphaFold 3 Server Outputs

**Installation:**
```bash
git clone https://github.com/scottcsh/af3filter.git
```

**Requirements: jq**
in Centos7
```bash
yum install jq -y
```

**Usage:**

./AF3_filter.sh --dir <json directory> [--out <output filename>] [--iptm <threshold>] [--ptm <threshold>] [--score <threshold>] [--pae <threshold>] [--max_output <N>]

Options:
  --dir         Root directory containing JSON files (required)
  
  --out         Output CSV filename (optional, default: results.csv)
  
  --iptm        Minimum iptm value (optional)
  
  --ptm         Minimum ptm value (optional)
  
  --score       Minimum ranking_score value (optional)
  
  --pae         Maximum allowed chain_pair_pae_min[0][1] value (optional)
                in default, PAE of the second chain is selected
  
  --max_output  Limit output to top N entries sorted by average(iptm, ptm, score)
  
  --help        Show help message

**Example**

./AF3_filter.sh --dir folds_2026_01_20_02_08/ --iptm 0.7 --ptm 0.7 --score 0.8 --pae 1.8 --max_output 20


<p align="center">
<img src="./images/mint_choco_latte.png" alt="cats" width="50%"/>
</p>

# af3filter
Filter AlphaFold 3 Server Outputs

**Installation:**
```bash
git clone https://github.com/scottcsh/af3filter.git
```

**Requirements:**

jq in Centos7
```bash
yum install jq -y
```

**Usage:**
1. Run & Download alphafold results from https://alphafoldserver.com/ in zip file
2. Unzip the results, run the script as:
./AF3_filter.sh --dir <json directory> [--out <output filename>] [--iptm <threshold>] [--ptm <threshold>] [--score <threshold>] [--pae <threshold>] [--max_output <N>]

**Options:**
<pre>
  --dir			Root directory containing JSON files (required)
  
  --out			Output CSV filename (optional, default: results.csv)
  
  --iptm		Minimum iptm value (optional)
  
  --ptm			Minimum ptm value (optional)
  
  --score		Minimum ranking_score value (optional)
  
  --pae			Maximum allowed chain_pair_pae_min[0][1] value (optional)
               		(in default, PAE of the second chain is selected)
  
  --max_output	Limit output to top N entries sorted by average(iptm, ptm, score)
  
  --help		Show help message
</pre>
**Example:**
```bash
./AF3_filter.sh --dir folds_2026_01_20_02_08/ --iptm 0.7 --ptm 0.7 --score 0.8 --pae 1.8 --max_output 20
```

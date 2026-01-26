<p align="center">
<img src="./images/mint_choco_latte.png" alt="cats" width="75%"/>
</p>

**Installation:**
```bash
git clone https://github.com/scottcsh/af3filter.git
```

# af3filter
Filter AlphaFold 3 Server Outputs

**Requirements:**

jq in Centos7
```bash
yum install jq -y
```

**Usage:**
1-1. Run & Download alphafold results from https://alphafoldserver.com/ in zip file
1-2. Run alphafold 3 in the local workstation
2. Unzip the results, run the script as:
./AF3_filter.sh --dir <json directory> [--out <output filename>] [--iptm <threshold>] [--ptm <threshold>] [--score <threshold>] [--pae <threshold>] [--chain_id <A-E>] [--max_output <N>]

**Options:**
<pre>
  --dir			Root directory containing JSON files (required)
  
  --out			Output CSV filename (optional, default: results.csv)
  
  --iptm		Minimum iptm value (optional)
  
  --ptm			Minimum ptm value (optional)
  
  --score		Minimum ranking_score value (optional)
  
  --pae			Maximum allowed chain_pair_pae_min[0][1] value (optional)
               		(in default, PAE of the second chain is selected)
  
  --chain_id    Chain ID (A–E) to select chain_pair_pae_min value
  
  --max_output	Limit output to top N entries sorted by average(iptm, ptm, score)
  
  --help		Show help message
</pre>
**Example:**
```bash
./AF3_filter.sh --dir folds_2026_01_20_02_08/ --iptm 0.7 --ptm 0.7 --score 0.8 --pae 1.8 --chain_id A --max_output 50
```

# mpnn2afserver
Process ProteinMPNN fasta files into AFserver_input.json

**Usage:**
./mpmm2afserver.sh --dir [fasta directory] --fa [target protein fasta]

**Example:**
```bash
./mpnn2afserver.sh --dir seqs/ --fa 1sy6.fa
```

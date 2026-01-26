import glob
import os
from pymol import cmd

# PDB input directory
pdb_path = r"C:\Lab\DATA\CDs\1SY6_CD3er\design\260119_pdb_outputs_only\*.pdb"

# PDB thumbnails output directory
output_dir = r"C:\Lab\DATA\CDs\1SY6_CD3er\design\260119_pdb_thumbnails"
os.makedirs(output_dir, exist_ok=True)

# Import PDB files
files = glob.glob(pdb_path)

# Process with batch size of 100
batch_size = 100
for i in range(0, len(files), batch_size):
    batch = files[i:i+batch_size]
    for f in batch:
        obj_name = os.path.basename(f).replace(".pdb", "")

        cmd.load(f, obj_name)
        cmd.hide("everything", obj_name)
        cmd.show("cartoon", obj_name)
        cmd.orient(obj_name)
        
        out_file = os.path.join(output_dir, f"{obj_name}.png")
        cmd.png(out_file, dpi=150)
        
        cmd.delete(obj_name)
    print(f"Batch {i//batch_size + 1} done ({len(batch)} files)")
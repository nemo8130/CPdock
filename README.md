# CPdock

Requires PERL (v.5.8 or higher), and a fortran90 compiler (prefered: ifort)
and four additional packages to be pre-installed 
Make sure they run under the executable command as prescribed for each

1. sc from ccp4 (http://www.ccp4.ac.uk/) [executable_name: sc]
2. delphi v.6.2 (http://compbio.clemson.edu/delphi) [executable_name: delphi95]
3. EDTSurf (http://zhanglab.ccmb.med.umich.edu/EDTSurf/) [executable_name: EDTSurf]
4. Reduce v.3 (http://kinemage.biochem.duke.edu/software/reduce.php) [executable_name: reduce]

### Installation

```sh
$ git clone https://github.com/nemo8130/CPdock
$ cd CPdock
$ chmod +x compileF
$ ./compileF <fortran90-compiler>  (Default: ifort)
```
open `CPdock` in any text editor and change the fullpaths for the following fields according to your system: 

- sc_path=/software/apps/ccp4/ccp4-6.5.0/ccp4-6.5/bin
- delphi_path=/home/sankar/bin
- ESpath=/home/sankar/bin
- reduce3path=/home/sankar/bin
- reducelib=/home/sankar/lib

### The input to the program is just the PDB file containing exactly two protein chains and without any HEADER (i.e., containing just the ATOM records)
- metal ions can be included under HETATM records but restricted to a list to be found at CPdock/LIBR/met.radii
- The PDB file must contain two and exactly two chains with seperate identifiers (e.g., A, B)
- The default choice of dielectric method (for computing EC) is set to the 'multi-dielectric' mode
- In case you want to switch to the single-dielectric mode, 
  open the main script file CPdock in a text editor and search for the phrase 'runEC'
- Go to that line and change the last argument from 1 to 0 

```sh
./runEC $pdb $delphi_path $ESpath 1 -> ./runEC $pdb $delphi_path $ESpath 0 
```

##### Usage:
```sh
$ ${exec_path}/CPdock <PDB.pdb>
```
where,
- PDB.pdb is the input pdb (coordinate file in Brrokheaven format; http://www.ccp4.ac.uk/html/procheck_man/manappb.html) file containing an extension of .pdb

> Output: the CPdock plot for the input PDB (in post script format) 
> gv requires to be installed and working under the command 'gv'
> The other text output is ${basename}.ScEC containing the Sc, EC values in format (f8.3,1x,f8.3)

> In addition you can get the ASA parameters in a file cat ${basename}.asaAngsq (Example as follows)
> |BSAmean---|     |ASA12-----|     |nBSA------|     |fracI-----|
>  1188.17798      17537.30469          0.06775          0.16106


> EXAMPLE PDB FILES ARE PROVIDED IN CPdock/TESTPDBS

### Use CPdock for the initial screening of your protein-protein docked models in a docking scoring pipeline








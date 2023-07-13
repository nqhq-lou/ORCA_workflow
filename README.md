# ORCA workflow

- Convert xyz files to orca input files by Python
- Run orca calculation controlled by bash scripts
- Extract information from orca by Python

- As examples, I used part (12 configurations) of the QM7 dataset and calculated SPE with ORCA DLPNO-CCSD(T) method.



## Notice

- This is not built for slurm or other cluster managing systems.
- ORCA ccsd(t) `nproc` should not exceed number of electrons
    - This results in more problems with working on a cluster
- I use the name ***thread***, which refers a bash script that will start ORCA calculations in sequence.
    - This might be confusing, and if you have a better name for it, please let me know.



## file structure

```text
orca_workflow
├── .env  # DO REMEMBER TO MODIFY THIS FILE
├── README.md
├── requirements.txt
├── inp  # ORCA input files
│   ├── [task_name].inp
│   └── ...
├── logs  # store log files and failed records
│   ├── failed
│   ├── [log_name].inp
│   └── ...
├── notebooks  # keep notebooks in this folder to make the project tidy
│   ├── gen_inp.ipynb
│   └── out2info.ipynb
├── out  # ORCA output files
│   ├── [task_name]  # this is a folder consists of all the output files of a single calculation
│   │   ├── [task_name].inp  # copied from `./inp` folder
│   │   ├── [task_name].out  # the output log file
│   │   └── ...
│   └── ...
├── scripts
│   ├── check_progress.sh  # check the currect finished / total tasks
│   ├── check_thread_duplicate.sh  # check if there are duplicate tasks names
│   ├── find_pids.sh  # find the pids of orca processes and bash control processes
│   ├── single_run.sh  # start a single calculation
│   ├── start_one_thread.sh  # start a single thread, which will start single calculations in sequence
│   ├── start_all_threads.sh  # start multiple threads in parallel
│   └── warn_run_at_PROJECT_ROOT
├── threads  # ORCA input files for threads, you could store thread files to othe folders
│   ├── [thread_name]
│   └── ...
├── xyz  # xyz files
│   ├── [task_name].xyz
│   └── ...
└── [other_files]
```

Also I provided the `qm7_xyz.tar` which consists of 7165 xyz files from QM7 dataset for you to try out the workflow.



## To start with

- Modify `.env` file
    - Set `PROJECT_ROOT` and `ORCA_PATH` (the abs path)
- Install `requirements.txt`
- And follow the follow procedures



## Procedures

- Follow `To start with` section
- Put xyzfiles in `./xyz` folder
- Generate `.inp` files and save to `./inp` folder
    - Using `./notebooks/gen_inp.ipynb`
- Split `.inp` files for threads and save to `./threads` folder
    - Using `./notebooks/gen_inp.ipynb`
- Run ORCA calculation controlled by bash scripts
    - `bash ./script/start_all_threads.sh [thread_dir]`
        - Make sure that run the script at `PROJECT_ROOT` folder
    - `.out` files will be placed in `./out` folder
    - Checkout `./logs/failed` file and rerun the failed `.inp` files
		- based on the `./logs/failed` file, create new thread dir and files and run `start_all_threads.sh` again
- (If failed, really sorry to hear that)
	- Just restart from `start_all_threads` script.
	- The script could identify the finished tasks and skip them.
- Extract information from `.out` files
    - Using `./notebooks/extract.ipynb`
    - Outputs will be saved in `./notebooks` folder


## Out folder

- There maybe working, finished, error empty files to indicated the current status
- `working` indicates the calculation is not finished
- `finished` indicates the calculation is finished
- No such files, indicated should restart the calculation (error or interrupted or not started yet)



## More features required:

- [x] remove `.env`, use `script_root=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)` to load projroot
- [ ] Parallelization in python
    - [ ] Processing `.inp` files
    - [ ] Extracting information from `.out` files
- [ ] `script/check_thread_duplicate.sh` strategy: newline


## Some tips

I tested acetaldehyde to find the best cal settings, and here is the result.

Here `walltime = nproc * runtime`

### parameters
- test on QM7 dataset
- SCF affect on SPE: small.
    - `TightSCF` > `VeryTightSCF` > `NormalSCF` > `LooseSCF`
    - just use `TightSCF`
- PNO has effect on SPE:
    - `TightPNO` > `LoosePNO` > `NormalPNO`
    - but still use `NormalPNO`
- focus on `TightSCF` and Normal PNO
    - considering the runtime
    - `DEF2-QZVPP` is the best basis set for `DLPNO-CCSD(T)` calculations, for smaller SPE reached
- restricted or unrestricted:
	- use restricted, unrestricted takes 3 times more time

### compare with other softwares

- adopted scheme: `TightSCF`, `NormalPNO`
	- runtime: 318.646 sec @ 24 nproc
	- walltime: 7647.504 sec

||orbitals|scf_level|pno_level|extrapolate|runtime|walltime|HF_E|T_E|Corr_E|SPE|d_HF_E|d_T_E|d_Corr_E|d_SPE|
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
|54|DEF2-QZVPP|TightSCF|NormalPNO|False|318.646|7647.504|-152.983856|-0.025331|-0.646664|-153.630519|0.000000|0.000173|0.000165|0.000165|
|30|CC-PVQZ|TightSCF|NormalPNO|False|353.257|8478.168|-152.981670|-0.025358|-0.648127|-153.629796|0.002186|0.000146|-0.001298|0.000887|
|42|DEF2-TZVPP|TightSCF|NormalPNO|False|77.859|1868.616|-152.976644|-0.022820|-0.610751|-153.587395|0.007212|0.002684|0.036077|0.043288|
|7|CC-PVTZ|TightSCF|NormalPNO|False|119.836|2876.064|-152.970349|-0.023073|-0.612558|-153.582908|0.013507|0.002432|0.034270|0.047776|
|18|DEF2-TZVP|TightSCF|NormalPNO|False|62.229|1493.496|-152.975249|-0.022270|-0.601023|-153.576271|0.008607|0.003234|0.045806|0.054413|

- m062x ksdft
	- restricted dft, default settings
	- runtime: 108.782867 sec @ 24 nproc, def2qzvpp
		- ORCA DLPNO-CCSD(T) is 3 times the KSDFT runtime

||basis|hf_e_tot|ht_runtime|ksdft_e_tot|ksdft_runtime|mock_correlation_energy|
|---|---|---|---|---|---|---|
|0|ccpvtz|-152.970350|1.679003|-153.815120|68.692879|-0.844770|
|1|def2tzvp|-152.975248|0.527590|-153.817361|51.181625|-0.842112|
|2|ccpvqz|-152.981670|21.002635|-153.825548|147.125949|-0.843878|
|3|def2tzvpp|-152.976644|1.177629|-153.818895|84.558870|-0.842251|
|4|def2qzvpp|-152.983855|12.715615|-153.831484|108.782867|-0.847628|

- Gaussian
	- `%nproc=64`
	- `%mem=200GB`
	- `%chk=./chkfiles/QM7_00500.chk`
	- `#p ccsd(T)/aug-cc-pvtz`
	- restricted cal
	- walltime: 171.5 sec
	- runtime: 10752.2 sec
	- ORCA @ def2qzvpp
		- 71% the walltime, while orbital is 4 zeta in ORCA compared to 3 zeta in Gaussian
	- for same orbital `CC-PVTZ`
		- walltime: ORCA 2876.064 sec, Gaussian 10752.2 sec
		- spe: ORCA -153.582908, Gaussian -153.5964995, Gaussian lower
		- spe difference: 0.0135915 Hartree, 8.53 kcal/mol
		- correlation energy: ORCA -0.612558, Gaussian -0.623726, Gaussian lower
```Python
{'nproc': 64,
 'mem': '200GB',
 'task': ['#p', 'single_point'],
 'method': 'ccsd(T)/aug-cc-pvtz',
 'charge': 0,
 'multiplicity': 1,
 'wall_time(sec)': 171.5,
 'cpu_time(sec)': 10752.2,
 'E_MP2': -153.5524044,
 'E_MP3': -153.5653544,
 'E_MP4D': -153.5794421,
 'E_MP4DQ': -153.5659729,
 'E_MP4SDQ': -153.5729361,
 'E_HF': -152.9727735,
 'E_CCSD': -153.5708637,
 'E_CCSD(T)': -153.5964995}
```


- best settings inp file
```inp
! UHF DLPNO-CCSD(T) DEF2-QZVPP DEF2-QZVPP/C TightSCF NormalPNO UseSym
%PAL NPROC 24 END
%MAXCORE 3000
* xyz 0 1
C       0.99381998      0.00934000     -0.00221000
C       2.48917010      0.03821000     -0.01128000
O       3.13976991      1.04803003     -0.26596999
H       0.65238001     -1.01326003     -0.19271000
H       0.60306999      0.66173002     -0.78594001
H       0.62986001      0.33136999      0.97585001
H       2.98791993     -0.88891000      0.31445001
*
```

### test on transient state of C2H6/ethan

- optimized geometry
```inp
! HF DLPNO-CCSD(T) DEF2-QZVPP DEF2-QZVPP/C TightSCF NormalPNO UseSym
%PAL NPROC 18 END
%MAXCORE 2000
* xyz 0 1
C                  0.76185700    0.00002000    0.00006600
C                 -0.76188000    0.00001500   -0.00002300
H                 -1.15681000    0.06580600    1.01418600
H                 -1.15664300    0.84543600   -0.56416600
H                 -1.15663000   -0.91129100   -0.45012000
H                  1.15677300    0.91146100    0.44991600
H                  1.15660800   -0.84559300    0.56411800
H                  1.15683700   -0.06603300   -1.01419700
*
```

- transient state
```inp
! HF DLPNO-CCSD(T) DEF2-QZVPP DEF2-QZVPP/C TightSCF NormalPNO UseSym
%PAL NPROC 18 END
%MAXCORE 2000
* xyz 0 1
C                  0.76838300    0.00004500    0.00002700
C                 -0.76834300    0.00000400    0.00001800
H                 -1.17120200   -0.15353700   -1.00035400
H                 -1.17121000   -0.78954500    0.63317400
H                 -1.17128100    0.94312200    0.36712400
H                  1.17105800   -0.78979400    0.63272600
H                  1.17100400   -0.15340200   -1.00029100
H                  1.17139100    0.94285800    0.36735300
*
```

- DLPNO-CCSD(T) results
```yaml
spe_C2H6: -79.698919476598
spe_C2H6_ts: -79.694505709045
spe_d: 0.004413767552989611
```

- Gaussian CCSD(T) results
```yaml
setting: '#p ccsd(T)/aug-cc-pvtz'
spe_C2H6: -79.67991
spe_C2H6_ts: -79.6754785
spe_d: 0.0044315
```

- compare DLPNO-CCSD(T) with gaussian CCSD(T)
	- 0.0000177 Hartree
	- 0.0111273 kcal/mol

- m062x results (by PySCF)
```yaml
mol:
    atom: C2H6
    unit: ang
    basis: def2qzvpp
    max_memory: 8000
spe_C2H6: -79.81469773093517
spe_C2H6_ts: -79.81043365138069
spe_d: 0.00426407955447416
```

- compare DLPNO-CCSD(T) with m062x
	- 0.000149688 Hartree
	- 0.09393 kcal/mol, less than 1 kcal/mol


**THE END OF README**

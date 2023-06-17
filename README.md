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
- Extract information from `.out` files
    - Using `./notebooks/extract.ipynb`
    - Outputs will be saved in `./notebooks` folder


## Out folder

- There maybe working, finished, error empty files to indicated the current status
- `working` indicates the calculation is not finished
- `finished` indicates the calculation is finished
- No such files, indicated should restart the calculation (error or interrupted or not started yet)



## More features required:

- [ ] Parallelization
    - [ ] Processing `.inp` files
    - [ ] Extracting information from `.out` files
- [ ] `script/check_thread_duplicate.sh` strategy: newline issue



## Some tips

I tested acetaldehyde to find the best cal settings, and here is the result.

Here `walltime = nproc * runtime`

### parameters

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

- adopted scheme
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
	- runtime: 108.782867 sec @ 24 nproc
	- 3 times the runtime

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
	- walltime: 171.5
	- runtime: 10752.2
	- 71% the walltime, while orbital is 4 zeta in ORCA compared to 3 zeta in Gaussian

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


**THE END OF README**
# ORCA workflow



## notice

- This is not built for slurm or other cluster managing systems.
- ORCA ccsd(t) `nproc` should not exceed number of electrons
    - this results in more problems with working on a cluster




## what to start with...

- xyz files
- python scripts



## procedure

- generate `.inp` files and save to `./inp` folder
- split `.inp` files for threads and save to `./threads` folder
- run ORCA
    - run `script/start_thread.sh`, which lives on `script/single_run.sh`
        - make sure that run script at `PROJECT_ROOT` folder
    - `.out` files will be placed in `./out` folder



## out folder

- there maybe working, finished, error empty files to indicated the current status
    - `working` indicates the calculation is not finished
    - `finished` indicates the calculation is finished
    - `error` indicates the calculation is failed


## more features required:

- parallelization for processing `.inp` files

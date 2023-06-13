# ORCA workflow



## notice

- This is not built for slurm systems.
- Orca ccsd(t) nproc should not exceed number of electrons, and this results in more problems.




## what to start with...

- xyz files
- python scripts



## procedure

- generate `.inp` files and save to `./inp` folder
- split `.inp` files for threads and save to `./threads` folder
- run ORCA
    - run `script/start_thread.sh`, which lives on `script/single_run.sh`
    - `.out` files will be placed in `./out` folder



## out folder

- there maybe working, finished, error empty files to indicated the current status
    - `working` indicates the calculation is not finished
    - `finished` indicates the calculation is finished
    - `error` indicates the calculation is failed


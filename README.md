# ORCA workflow



## notice

- this is not built for slurm or other cluster managing systems.
- ORCA ccsd(t) `nproc` should not exceed number of electrons
    - this results in more problems with working on a cluster



## to start with

- modify `.env` file
- install `requirements.txt`
- and follow the follow procedures


## procedures

- put xyzfiles in `./xyz` folder
- generate `.inp` files and save to `./inp` folder
    - using `./notebooks/gen_inp.ipynb`
- split `.inp` files for threads and save to `./threads` folder
    - using `./notebooks/gen_inp.ipynb`
- run ORCA calculation controlled by bash scripts
    - `bash ./script/start_all_threads.sh [thread_dir]`
        - make sure that run the script at `PROJECT_ROOT` folder
    - `.out` files will be placed in `./out` folder
- extract information from `.out` files
    - using `./notebooks/extract.ipynb`
    - outputs will be saved in `./notebooks` folder



## out folder

- there maybe working, finished, error empty files to indicated the current status
- `working` indicates the calculation is not finished
- `finished` indicates the calculation is finished
- no such files, indicated should restart the calculation (error or interrupted or not started yet)



## more features required:

- [ ] parallelization
    - [ ] processing `.inp` files
    - [ ] extracting information from `.out` files
- [ ] `script/check_thread_duplicate.sh` strategy: newline issue



**THE END OF README**
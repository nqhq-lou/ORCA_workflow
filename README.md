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



**THE END OF README**
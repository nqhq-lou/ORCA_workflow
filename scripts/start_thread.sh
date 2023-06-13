#! /bin/bash

thread_num=$1

source .env
cd $PROJECT_PATH


#### startup self-check ####

# check if folder inp, logs, out, threads exists
for dname in inp logs out threads; do
    if [ ! -d ${dname} ]; then
        mkdir ${dname}
    fi
done

# check if thread task file exists
if [ ! -f threads/thread_${thread_num}.txt ]; then
    echo "Thread file not found"
    exit 1
fi


#### preparations ####

# basics vars
orca_fpath=$ORCA_PATH
datefmt="%Y-%m-%d_%H:%M:%S_[%s.%N]"
time_stamp=$(date +"${datefmt}")
inp_dpath="${PROJECT_PATH}/inp"
out_dpath="${PROJECT_PATH}/out"
thread_fpath="${PROJECT_PATH}/threads/thread_${thread_num}.txt"
logs_fpath="${PROJECT_PATH}/logs/thread_${thread_num}_${time_stamp}.log"
failed_fpath="${PROJECT_PATH}/failed.txt"

# iter over thread file lines, each line is a tack name




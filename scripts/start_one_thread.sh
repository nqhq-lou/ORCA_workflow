#! /bin/bash
# start one thread
# input parameter is：the thread name (like thread_0)

thread_name=$1

source $(dirname $0)/find_project_root.sh
cd $PROJECT_ROOT


#### preparations ####

# basics vars
orca_fpath=$ORCA_PATH
datefmt="%Y-%m-%d_%H:%M:%S_%s.%N"
time_stamp=$(date +"${datefmt}")
inp_dpath="${PROJECT_ROOT}/inp"
out_dpath="${PROJECT_ROOT}/out"
thread_fpath="${PROJECT_ROOT}/threads/${thread_name}"
logs_fpath="${PROJECT_ROOT}/logs/${thread_name}_${time_stamp}.log"  # log in different files
failed_fpath="${PROJECT_ROOT}/logs/failed"
single_run="${PROJECT_ROOT}/scripts/single_run.sh"

# log function for convenience
function log {
    echo "[$(date +"${datefmt}")] $1" >> ${logs_fpath}
}

# in the thread file, each line is a tack name
# iterate over the lines and run each task
# while read task_name; do
for task_name in $(cat ${thread_fpath}); do
    task_root="${out_dpath}/${task_name}"  # this is a dir
    # check if finished or working
    for status in finished working; do
        if [ -f ${task_root}/${status} ]; then
            log "Task ${task_name} is ${status}, skip"
            continue 2  # two levels of loop, use continue 2 to break both
        fi
    done
    # check if inp exists
    if [ ! -f ${inp_dpath}/${task_name}.inp ]; then
        log "Task ${inp_dpath}/${task_name}.inp not found"
        continue
    fi
    # move inp file to out/$task_name folder
    mkdir -p ${task_root}
    cp ${inp_dpath}/${task_name}.inp ${task_root}/
    # run the task
    log "Task ${task_name} started"
    bash ${single_run} ${task_name} ${task_root} ${orca_fpath}
    # touch ${task_root}/finished
    # if found finished, log success; else log failed
    if [ -f ${task_root}/finished ]; then
        log "Task ${task_name} finished"
        continue
    else
        log "Task ${task_name} failed"
        # if it doesn't exist in failed file, log failed
        # else do nothing
        if ! grep -q ${task_name} ${failed_fpath}; then
            echo ${task_name} >> ${failed_fpath}
        fi
        continue
    fi
done


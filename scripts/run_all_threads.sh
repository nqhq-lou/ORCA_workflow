#! /bin/bash
# make sure to run at project root
# input parameters: thread_dname

if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    echo "run all threads available in the thread dir (thread_dname)"
    echo "usage: $(basename $0) [thread_dname]"
    exit 0
fi


source $(dirname $0)/find_project_root.sh
cd $PROJECT_ROOT
run_one_thread="${PROJECT_ROOT}/scripts/run_one_thread.sh"

thread_dname=$1

# check if thread_dname is provided
if [ -z ${thread_dname} ]; then
    echo "Please provide thread_dname as the first parameter"
    exit 1
fi

#### startup self-check ####

# # check duplicates
bash scripts/check_thread_duplicate.sh ${thread_dname}

# if return is 1, then exit
if [ $? -eq 1 ]; then
    exit 1
fi

# check if folder inp, logs, out, threads exists
for dname in logs out; do  # inp and threads must exist
    if [ ! -d ./${dname} ]; then
        mkdir ./${dname}
    fi
done

#### start threads ####

# get thread names
thread_names="$(ls ${thread_dname})"

# start threads, start them on background
for thread_name in ${thread_names}; do
    nohup bash ${run_one_thread} ${thread_dname} ${thread_name} > /dev/null 2>&1 &
    # bash ./scripts/run_one_thread.sh ${thread_name} &
    echo "Thread ${thread_name} started"
done


#! /bin/bash
# make sure to run at project root
# input parameters: thread_dname

source .env
cd $PROJECT_ROOT

thread_dname=$1

#### startup self-check ####

# # check duplicates
bash scripts/check_thread_duplicate.sh ${thread_dname}

# if return is 1, then exit
if [ $? -eq 1 ]; then
    exit 1
fi

# check if folder inp, logs, out, threads exists
for dname in logs out; do  # inp and threads must exist
    if [ ! -d ${dname} ]; then
        mkdir ${dname}
    fi
done

# check if logs/failed exists
if [ ! -f logs/failed ]; then
    touch logs/failed
fi


#### start threads ####

# get thread names
thread_names="$(ls ${thread_dname})"

# start threads, start them on background
for thread_name in ${thread_names}; do
    nohup bash ./scripts/start_one_thread.sh ${thread_name} > /dev/null 2>&1 &
    # bash ./scripts/start_one_thread.sh ${thread_name} &
    echo "Thread ${thread_name} started"
done


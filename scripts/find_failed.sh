#! /bin/bash
# find failed tasks
# input parameters: none

if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    echo "find and log all the failed tasks in logs dir"
    echo "usage: $(basename $0) [log_name(optional)]"
    exit 0
fi

source $(dirname $0)/find_project_root.sh
cd ${PROJECT_ROOT}


#### preparations ####
datefmt="%Y-%m-%d_%H:%M:%S_%s.%N"
time_stamp=$(date +"${datefmt}")
out_dpath=${PROJECT_ROOT}/out
if [ -z $1 ]; then
    log_fpath="${PROJECT_ROOT}/logs/failed_${time_stamp}.log"
else
    log_fpath="${PROJECT_ROOT}/logs/$1"
fi
touch log_fpath

if [ ! -d ${out_dpath} ]; then
    echo "out_dpath=${out_dpath} doesn't exist"
    return 1
fi

#### start checking ####
to_check_dnames="$(ls ${out_dpath})"

# check if file "finished" or file "working" in dirs in list ${to_check_dnames}
# if true, continue
# if false, echo dirname to log
for dname in ${to_check_dnames}; do
    dpath="${out_dpath}/${dname}"
    if [ -f "${dpath}/finished" ] || [ -f "${dpath}/working" ]; then
        # task is finished or working, skip it
        continue
    else
        # task is failed, log it
        echo "${dname}" >> "${log_fpath}"
    fi
done

#### print result
failed_cnt=$(cat ${log_fpath} | wc -l)

echo "failed cnt = ${failed_cnt}. See ${log_fpath} for failed tasks."





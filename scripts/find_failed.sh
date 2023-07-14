#! /bin/bash
# find failed tasks
# input parameters: none

source $(dirname $0)/find_project_root.sh
cd ${PROJECT_ROOT}


#### preparations ####
datefmt="%Y-%m-%d_%H:%M:%S_%s.%N"
time_stamp=$(date +"${datefmt}")
out_dpath=${PROJECT_ROOT}/out
log_fpath="${PROJECT_ROOT}/logs/failed_${time_stamp}.log"
touch log_fpath

# check if out_dpath exists
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





#! /bin/bash
# purpose: run a single task and check if finished
# input parameters: task_name, task_root, orca_fpath

if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    echo "run one orca calculation task"
    echo "the inp file should be already placed in the task dir [task_root]"
    echo "usage: $(basename $0) [task_name] [task_root] [orca_fpath]"
    exit 0
fi

# if finished, then touch finished
# else, do nothing

task_name=$1
task_root=$2
orca_fpath=$3

cd $task_root  # doesn't affect the main process
touch working

# check if inp exists
if [ ! -f "${task_name}.inp" ]; then
    echo "task ${task_name}.inp not found"
    rm working
    exit 1
fi

# run the task
${orca_fpath} ${task_name}.inp > ${task_name}.out
# touch finished

# check if finished
# if finished file exists, then the task is finished
if grep -q "FINAL SINGLE POINT ENERGY" ${task_name}.out; then
    touch finished
    rm working
    exit 0
else
    rm working
    exit 1
fi


#! /bin/bash
# purpose: check if there are duplicate tasks in all thread files
# input parameters: thread_dname

# files in threads dir consists of lines, each line for one task name
# find if there are duplicate tasks in all thread files

source $(dirname $0)/find_project_root.sh
cd $PROJECT_ROOT

thread_dname=$1

# get all thread files
thread_files=$(ls ${thread_dname})

# get all task names
# first start a list to store all task names
task_names=$(cat ${thread_dname}/*)
# TODO: if file doesn't end with newline, then the last task name will be ignored

# print total number of tasks
echo "Total number of tasks: $(echo "${task_names}" | wc -l)"

# get all duplicated task names
duplicated_task_names=$(echo "${task_names}" | uniq -d)

# if there are duplicated task names, print them
if [ -n "${duplicated_task_names}" ]; then
    echo "Duplicated task names found:"
    # find in which thread file
    for task_name in ${duplicated_task_names}; do
        for thread_file in ${thread_files}; do
            if grep -q ${task_name} threads/${thread_file}; then
                echo "Task name: ${task_name}    Found in thread file: ${thread_file}"
            fi
        done
    done
    exit 1  # if change this, remember to change scripts/start_full.sh
fi

# if there are no duplicated task names, print success
echo "No duplicated task names found"
exit 0


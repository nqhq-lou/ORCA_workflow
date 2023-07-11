#! /bin/bash
# purpose: check the progress of the orca workflow
# output: [number of successful outputs] / [number of total inputs]

source $(dirname $0)/find_project_root.sh
cd $PROJECT_ROOT

# in the `out` folder, there are task folders
# if the task is finished, then there is a file named `finished` in the task folder
# count the number of `finished` files
# here is the code
finished=$(find out -name finished | wc -l)

# in the `inp` folder, there are .inp files as input
# count the number of .inp files
# here is the code
total=$(find inp -name "*.inp" | wc -l)

# print the result, with format [finished] / [total]
echo "${finished} / ${total} (finished / total)"



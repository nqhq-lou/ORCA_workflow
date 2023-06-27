#! /bin/bash
# find father dirs where there is .env file
# add PROJECT_ROOT to env var and source .env

# get the directory of the script
dir=$(realpath $(dirname "${BASH_SOURCE[0]}"))

# loop until the .env file is found or the root directory is reached
while [[ ! -f "$dir/.env" && "$dir" != "/" ]]; do
    # go to the parent directory
    dir=$(dirname "$dir")
done

# check if the .env file exists
if [[ -f "$dir/.env" ]]; then
    # source the .env file
    source "$dir/.env"
    export PROJECT_ROOT=$(realpath $dir)
else
    # return error
    echo "No .env file found in any parent directory"
    exit 1
fi

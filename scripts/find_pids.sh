#! /bin/bash
# purpose: find pids of all running threads. Not mpi threads, but task threads.

echo "running start_one_thread.sh:"

ps -ef | grep ./scripts/start_one_thread.sh | grep -v grep | awk '{print $2}'

echo "running single_run.sh:"

ps -ef | grep ./scripts/single_run.sh | grep -v grep | awk '{print $2}'

#! /bin/bash
# purpose: find pids of all running threads. Not mpi threads, but task threads.

echo "running run_one_thread.sh:"

ps -ef | grep ./scripts/run_one_thread.sh | grep -v grep | awk '{print $2}'

echo "running run_one_task.sh:"

ps -ef | grep ./scripts/run_one_task.sh | grep -v grep | awk '{print $2}'

#!/bin/bash

set -e
export HOME="/workingdir"
service openvas-scanner restart \
	&& service openvas-gsa restart \
	&& lsof -i \
	&& tmux new-session -s 'tmuxed-1' -n 'app1' -d \
	&& tmux split-window -t 0 -v \
	&& tmux split-window -t 0 -h \
	&& tmux split-window -t 1 -h \
	&& tmux resize-pane -t 1 -U -y 20 \
	&& tmux send -t 0 'tcpdump port 9390' ENTER \
	&& tmux send -t 1 'openvasmd -f --listen=127.0.0.1 --port=9390 --database=/var/lib/openvas/mgr/tasks.db' ENTER \
	&& tmux send -t 2 'trap ctrl_c INT;ctrl_c(){ echo "*quitting"; tmux kill-server ; }' ENTER \
	&& tmux send -t 2 'clear' ENTER \
	&& tmux send -t 2 'echo -e "\n********\nCTRL+C to quit\*********"' ENTER \
	&& tmux send -t 3 'tail -F /var/log/openvas/openvasmd.log' ENTER \
	&& tmux at -t 'tmuxed-1'

exec "$@"

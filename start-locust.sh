#!/bin/env bash

# Create a new tmux session named "locust-cluster" and detach
tmux new-session -d -s locust-cluster -c "$(pwd)" -n 'locust-master'
tmux send-keys -t locust-cluster 'vagrant ssh locust-master' C-m
tmux send-keys -t locust-cluster 'cd /vagrant' C-m
tmux send-keys -t locust-cluster 'locust -f locustfile.py --master --master-bind-host=0.0.0.0 --host=http://192.168.56.50' C-m

# create new window for the locust-worker panes
tmux new-window -t locust-cluster:2 -n 'locust-worker'

for i in {1..3}; do
  # Split horizontally when not on the first pane
  if [ $i -ne 1 ]; then
    tmux split-window -v -t locust-cluster
  fi
  tmux send-keys -t locust-cluster:2.$i "vagrant ssh locust-worker-$i" C-m
  tmux select-layout -t locust-cluster even-vertical
done

# Set synchronization mode to broadcast input to all panes
tmux set-window-option -t locust-cluster synchronize-panes on
tmux send-keys 'cd /vagrant' C-m
tmux send-keys 'locust -f locustfile.py --worker --master-host=192.168.56.10 --processes=-1' C-m

tmux select-window -t locust-cluster:1

# Attach to the session
tmux attach -t locust-cluster

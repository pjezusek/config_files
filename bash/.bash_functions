#!/bin/bash

# Setups monitor's resolution, panning and position
#
# Needs:
# - PRIMARY_MONITOR - name of primary monitor
# - SECONDARY_MONITOR - name of secondary monitor (optional)
# - SECONDARY_MONITOR_LOCATION - location of secondary monitor (optional)
# - RESOLUTION - monitors resolution
setup_monitors() {
  xrand --output $PRIMARY_MONITOR --mode $RESOLUTION --fb $RESOLUTION --panning $RESOLUTION --primary
  if [[ $SECONDARY_MONITOR != "" ]]; then
    xrand --output $SECONDARY_MONITOR --mode $RESOLUTION --panning $RESOLUTION $SECONDARY_MONITOR_LOCATION
  fi
}

# Initializes tmux sessions
#
# Needs:
# - SESSIONS - list of sessions to initialize
setup_tmux() {
	local tmux_sessions_list=$(tmux ls | sed 's/://' | awk {'print $1'})	
  if [[ $? = 0 ]]; then
    declare -A tmux_sessions_dictionary
    for session in ${tmux_sessions_list[@]}
    do
      tmux_sessions_dictionary[$session]=true
    done
    for session in ${SESSIONS[@]}
    do
      if [[ ${tmux_sessions_dictionary[$session]} != true ]]; then
        tmux new -d -s $session
        tmux send -t "${session}" "teamocil --here ${session}" ENTER
      fi
    done
  else
    for session in ${SESSIONS[@]}
    do
      tmux new -d -s $session
      tmux send -t "${session}" "teamocil --here ${session}" ENTER
    done
  fi
  tmux a
}

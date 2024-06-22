# fix the zsh prompt to show the hostname instead of the %m.
# to do this, we need to change the $prompt_pure_state[username] variable.
# because pure capture prompt_pure_state when the shell is started,
# we need to change it after the shell is started.

prompt_pure_state[username]=$(echo $prompt_pure_state[username] | sed "s/%m/$(hostname -s)/g")


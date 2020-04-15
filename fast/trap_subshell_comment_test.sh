source "$rvm_path/scripts/rvm"

eval 'shell_session_update() { echo hi'$'\n''}' # status=0
typeset -f shell_session_update # status=0

echo $(cd . > /dev/null && echo a) # status=0; match=/^a$/

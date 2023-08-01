
#!/usr/bin/env bash
#
# ABOUT
# These functions configure auditing
# 
# PROVIDES
# remove_bash_history_symlink


#######################################
# Reset bash logging
# Globals:
#   nil
# Arguments:
#   $0 its own name
# Outputs:
#   Nil
#######################################
function remove_bash_history_symlink(){
    bash_history_filepath="~/.bash_history"
    if [[ ! -L "${bash_history_filepath}" ]]; then
        rm "${bash_history_filepath}"
    fi
}
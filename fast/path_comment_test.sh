source "$rvm_path/scripts/rvm"

: add/remove
__rvm_remove_from_path /test-bin    # env[PATH]!=//test-bin/
org_path1=$PATH                     # env[PATH]=/rvm/

__rvm_add_to_path append /test-bin  # env[PATH]=//test-bin/
[[ $PATH == $org_path1:/test-bin ]] # status=0
__rvm_remove_from_path /test-bin    # env[PATH]!=//test-bin/

__rvm_add_to_path prepend /test-bin # env[PATH]=//test-bin/
[[ $PATH == /test-bin:$org_path1 ]] # status=0
__rvm_remove_from_path /test-bin    # env[PATH]!=//test-bin/

: remove_rvm
org_path1=$PATH                # env[PATH]=/rvm/
__rvm_remove_rvm_from_path     # env[PATH]!=/rvm/
org_path2=$PATH
PATH=$rvm_path/bin:$PATH:$rvm_path/bin
__rvm_remove_rvm_from_path     # env[PATH]!=/rvm/

[[ $org_path1 == $org_path1 ]] # status=0

: clean_path
org_path1=$rvm_path/bin:$PATH
PATH=$rvm_path/bin:$PATH:$rvm_path/bin
__rvm_clean_path               # env[PATH]=/rvm/
[[ $PATH == $org_path1 ]]      # status=0

: conditionally add bin path
__rvm_remove_rvm_from_path                   # env[PATH]!=/rvm/
org_path1=$PATH

unset rvm_ruby_string
__rvm_conditionally_add_bin_path             # env[PATH]=/rvm/
[[ $PATH == $org_path1:$rvm_path/bin ]] # status=0

__rvm_remove_rvm_from_path                   # env[PATH]!=/rvm/
rvm_ruby_string=ruby-1.9.3-p124
__rvm_conditionally_add_bin_path             # env[PATH]=/rvm/
[[ $PATH == $rvm_path/bin:$org_path1 ]] # status=0

## no __rvm_remove_rvm_from_path
unset rvm_ruby_string
__rvm_conditionally_add_bin_path             # env[PATH]=/rvm/
[[ $PATH == $rvm_path/bin:$org_path1 ]] # status=0

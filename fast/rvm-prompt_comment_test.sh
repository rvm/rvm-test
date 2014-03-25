source "$rvm_path/scripts/rvm"

command rvm install 1.8.7
command rvm install 1.9.3
command rvm install 2.0.0

rvm 1.9.1 do rvm-prompt      # match=/Ruby (ruby-)?1.9.1(-p[[:digit:]]+)? is not installed./
rvm 1.9.3 do rvm-prompt      # match=/^ruby-1.9.3-p[[:digit:]]+$/
rvm 2.0.0 do rvm-prompt i    # match=/^ruby$/
rvm 2.0.0 do rvm-prompt i v  # match=/^ruby-2.0.0$/
rvm 2.0.0 do rvm-prompt v    # match=/^2.0.0$/
rvm 2.0.0 do rvm-prompt v p  # match=/^2.0.0-p[[:digit:]]+$/
rvm system do rvm-prompt     # match=/^$/
rvm system do rvm-prompt s v # match=/^system$/
rvm 1.8.7 do rvm-prompt s v  # match=/^1.8.7$/

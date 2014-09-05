source "$rvm_path/scripts/rvm"

command rvm install 2.1.2
command rvm install 2.1.1
command rvm install 2.0.0

rvm 1.9.1 do rvm-prompt      # match=/Ruby (ruby-)?1.9.1(-p[[:digit:]]+)? is not installed./
rvm 2.1.1 do rvm-prompt      # match=/^ruby-2.1.1$/
rvm 2.0.0 do rvm-prompt i    # match=/^ruby$/
rvm 2.0.0 do rvm-prompt i v  # match=/^ruby-2.0.0$/
rvm 2.0.0 do rvm-prompt v    # match=/^2.0.0$/
rvm 2.0.0 do rvm-prompt v p  # match=/^2.0.0-p[[:digit:]]+$/
rvm system do rvm-prompt     # match=/^$/
rvm system do rvm-prompt s v # match=/^system$/
rvm 2.1.2 do rvm-prompt s v  # match=/^2.1.2$/

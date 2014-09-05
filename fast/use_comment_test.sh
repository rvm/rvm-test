source "$rvm_path/scripts/rvm"

command rvm install 2.1.0
command rvm install 2.1.1

rvm use 9.9.9           # status=1; match!=/Using /; env[GEM_HOME]!=/9.9.9/ ; match=/Unknown ruby interpreter version/
rvm reset               # env[GEM_HOME]=/^$/
rvm current             # match=/system/
rvm use 2.1.0      # status=0; match=/Using / ; env[GEM_HOME]=/2.1.0/
rvm current             # match=/2.1.0/
command rvm use 2.1.1   # status=0; match!=/Using /; env[GEM_HOME]!=/2.1.1/ ; match=/RVM is not a function/
rvm use 2.1.1           # status=0; match=/Using / ; env[GEM_HOME]=/2.1.1/
rvm use 1.9.1           # status=1; env[rvm_recommended_ruby]=/rvm install ruby-1.9.1/

source "$rvm_path/scripts/rvm"

command rvm install 1.8.7-p374
command rvm install 1.9.3

rvm use 9.9.9           # status=1; match!=/Using /; env[GEM_HOME]!=/9.9.9/ ; match=/Unknown ruby interpreter version/
rvm reset               # env[GEM_HOME]=/^$/
rvm current             # match=/system/
rvm use 1.8.7-p374      # status=0; match=/Using / ; env[GEM_HOME]=/1.8.7/
rvm current             # match=/1.8.7/
command rvm use 1.9.3   # status=0; match!=/Using /; env[GEM_HOME]!=/1.9.3/ ; match=/RVM is not a function/
rvm use 1.9.3           # status=0; match=/Using / ; env[GEM_HOME]=/1.9.3/
rvm use 1.9.1           # status=1; env[rvm_recommended_ruby]=/rvm install ruby-1.9.1/

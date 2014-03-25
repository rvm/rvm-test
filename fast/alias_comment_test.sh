source "$rvm_path/scripts/rvm"

rvm use 1.9.3-484 --install
rvm use 1.9.3 --install
rvm gemset create test_gemset

rvm alias create default 1.9.3@test_gemset # status=0
ls -l $rvm_path/environments/default       # status=0; match=/1.9.3.*@test_gemset/
rvm alias list                             # match=/^default => ruby-1.9.3.*@test_gemset$/
rvm alias delete default                   # status=0
ls -l $rvm_path/environments/default       # status!=0

rvm alias create ruby-test-default 1.9.3@test_gemset # status=0
ls -l $rvm_path/environments/ruby-test-default       # status=0
rvm alias list                                       # match=/^ruby-test-default => ruby-1.9.3.*@test_gemset$/
rvm alias list names                                 # match=/^ruby-test-default$/
rvm alias delete ruby-test-default                   # status=0
ls -l $rvm_path/environments/ruby-test-default       # status!=0

rvm --force gemset delete test_gemset

: overwrite existing aliases
rvm alias create veve 1.9.3-p484  # status=0
ls -l $rvm_path/environments/veve # status=0; match=/1.9.3-p484/
ls -l $rvm_path/wrappers/veve     # status=0; match=/1.9.3-p484/
rvm alias list                    # match=/^veve => ruby-1.9.3-p484$/
rvm alias create veve 1.9.3       # status=0
ls -l $rvm_path/environments/veve # status=0; match=/1.9.3/
ls -l $rvm_path/wrappers/veve     # status=0; match=/1.9.3/
rvm alias list                    # match=/^veve => ruby-1.9.3-p.*$/
rvm alias delete veve             # status=0
ls -l $rvm_path/environments/veve # status!=0
rvm alias list                    # match!=/^veve => /

source "$rvm_path/scripts/rvm"

rvm use 1.8.7 --install # status=0
rvm gemset create test1 # status=0
rvm gemset create test2 # status=0

: do
rvm 9.9.9 do rvm gemdir # status=1; match=/is not installed/
rvm 1.8.7 do rvm gemdir # status=0; match=/1.8.7-p[[:digit:]]+/
## bad error msg - but good status
rvm 1.8.7@test0 do rvm gemdir # status=1; match=/is not installed/
rvm 1.8.7@test1 do rvm gemdir # status=0; match=/1.8.7-p[[:digit:]]+@test1/
rvm 1.8.7@test2 do rvm gemdir # status=0; match=/1.8.7-p[[:digit:]]+@test2/

rvm 1.8.7@global,1.8.7 do rvm gemdir # status=0; match=/1.8.7-p[[:digit:]]+@global$/; match=/1.8.7-p[[:digit:]]+$/

rvm --force gemset delete test1 # status=0
rvm --force gemset delete test2 # status=0

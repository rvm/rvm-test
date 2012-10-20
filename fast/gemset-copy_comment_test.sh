source "$rvm_path/scripts/rvm"

rvm use 1.8.7 --install

:
rvm gemset copy 1.8.7 1.8.7@testset # status=0; match=/Copying gemset/; match[stderr]=/^$/
rvm gemset list                     # status=0; match=/ testset$/
rvm gemset --force delete testset   # status=0; match=/^Removing gemset testset$/
rvm gemset list                     # status=0; match!=/ testset$/

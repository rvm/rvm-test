source "$rvm_path/scripts/rvm"

rvm try_install 1.8.7-p374
rvm try_install 1.9.3
rvm try_install 2.0.0

: separate default/current
rvm use 1.8.7-p374@abc-test --create --default
# status=0
# match=/Using .*ruby-1.8.7.* with gemset abc-test/
rvm current
# match=/ruby-1.8.7.*@abc-test/

rvm use 1.9.3@abc-test --create
# status=0
# match=/Using .*ruby-1.9.3.* with gemset abc-test/
rvm current
# match=/ruby-1.9.3.*@abc-test/

rvm list
# match=/^ \* ruby-1.8.7-p374/
# match=/^=> ruby-1.9.3/

: default == current
rvm use 2.0.0@abc-test --create --default
# status=0
# match=/Using .*ruby-2.0.0.* with gemset abc-test/
rvm current
# match=/ruby-2.0.0.*@abc-test/

rvm list
# match=/^=\* ruby-2.0.0/

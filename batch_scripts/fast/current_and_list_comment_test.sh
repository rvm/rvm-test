source "$rvm_path/scripts/rvm"

rvm install 1.8.7
rvm install 1.9.2
rvm install 1.9.3

: separate default/current
rvm use 1.8.7@abc-test --create --default
# status=0
# match=/Using .*ruby-1.8.7.* with gemset abc-test/
rvm current
# match=/ruby-1.8.7.*@abc-test/

rvm use 1.9.2@abc-test --create
# status=0
# match=/Using .*ruby-1.9.2.* with gemset abc-test/
rvm current
# match=/ruby-1.9.2.*@abc-test/

rvm list
# match=/^ \* ruby-1.8.7/
# match=/^=> ruby-1.9.2/

: default == current
rvm use 1.9.3@abc-test --create --default
# status=0
# match=/Using .*ruby-1.9.3.* with gemset abc-test/
rvm current
# match=/ruby-1.9.3.*@abc-test/

rvm list
# match=/^=\* ruby-1.9.3/

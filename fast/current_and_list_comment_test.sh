source "$rvm_path/scripts/rvm"

rvm try_install 2.1.1
rvm try_install 2.1.0
rvm try_install 2.0.0

: separate default/current
rvm use 2.1.1@abc-test --create --default
# status=0
# match=/Using .*ruby-2.1.1 with gemset abc-test/
rvm current
# match=/ruby-2.1.1@abc-test/

rvm use 2.1.0@abc-test --create
# status=0
# match=/Using .*ruby-2.1.0 with gemset abc-test/
rvm current
# match=/ruby-2.1.0@abc-test/

rvm list
# match=/^ \* ruby-2.1.1/
# match=/^=> ruby-2.1.0/

: default == current
rvm use 2.0.0@abc-test --create --default
# status=0
# match=/Using .*ruby-2.0.0.* with gemset abc-test/
rvm current
# match=/ruby-2.0.0.*@abc-test/

rvm list
# match=/^=\* ruby-2.0.0/

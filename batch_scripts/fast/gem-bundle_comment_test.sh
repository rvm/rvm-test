source "$rvm_path/scripts/rvm"

: setup/pretest
rvm @global do gem uninstall bundler
bundle config
hash                # match=/bundle/
rvm use --create @gemtest
hash                # match!=/bundle/

: test
bundle config       # status!=0 ; match=/Gem bundler is not installed/
gem install bundler # status=0
bundle config       # status=0 ; match=/Settings are listed in order of priority/

: reset
rvm gemset use default
rvm --force gemset delete gemtest # status=0

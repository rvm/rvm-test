source "$rvm_path/scripts/rvm"

rvm remove  1.8.7-ntest --gems
rvm install 1.8.7-ntest --skip-gemsets
# status=0
# match!=/Already installed/
# match=/Applying patch/
# match=/Skipped importing default gemsets/
# match=/patches just to be compiled on/

rvm install 1.8.7-ntest
# status=0; match=/Already installed/

rvm 1.8.7-ntest do which gem
# match=/1.8.7-p[[:digit:]]+-ntest/

rvm 1.8.7-ntest do gem env

rvm 1.8.7-ntest do gem list
# match[stderr]=/\A\Z/
# match[stdout]!=/bundler/
# match[stdout]!=/rake/
# match[stdout]!=/rubygems-bundler/
# match[stdout]!=/rvm/

rvm 1.8.7-ntest do ruby -v
# match=/1.8.7/

rvm remove 1.8.7-ntest --gems
# status=0; match=/Removing/

find -L $rvm_path/environments -regextype posix-extended -regex '.*1.8.7-p[[:digit:]]+-ntest.*' -print -quit # match=/^$/
find -L $rvm_path/wrappers     -regextype posix-extended -regex '.*1.8.7-p[[:digit:]]+-ntest.*' -print -quit # match=/^$/
find -L $rvm_path/gems         -regextype posix-extended -regex '.*1.8.7-p[[:digit:]]+-ntest.*' -print -quit # match=/^$/
find -L $rvm_path/bin          -regextype posix-extended -regex '.*1.8.7-p[[:digit:]]+-ntest.*' -print -quit # match=/^$/

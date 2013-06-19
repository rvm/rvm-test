source "$rvm_path/scripts/rvm"

rvm remove  1.8.7-ntest --gems

## without gemsets

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

rvm remove  1.8.7-ntest --gems
# status=0; match=/Removing/


## default/global gemsets

mkdir -p $rvm_path/gemsets/ruby/1.8.7/
echo haml > $rvm_path/gemsets/ruby/1.8.7/default.gems
echo tf > $rvm_path/gemsets/ruby/1.8.7/global.gems

rvm install 1.8.7-ntest
# status=0
# match!=/Already installed/
# match=/Applying patch/
# match=/importing default gemsets, this may take time/
# match=/patches just to be compiled on/

rvm 1.8.7-ntest do gem list
# match[stderr]=/\A\Z/
# match[stdout]=/haml/
# match[stdout]=/tf/

rvm 1.8.7-ntest@global do gem list
# match[stderr]=/\A\Z/
# match[stdout]!=/haml/
# match[stdout]=/tf/

## Cleanup

rvm remove 1.8.7-ntest --gems
# status=0; match=/Removing/

rm -rf $rvm_path/gemsets/ruby/1.8.7/

find -L $rvm_path/environments -regextype posix-extended -regex '.*1.8.7-p[[:digit:]]+-ntest.*' -print -quit # match=/^$/
find -L $rvm_path/wrappers     -regextype posix-extended -regex '.*1.8.7-p[[:digit:]]+-ntest.*' -print -quit # match=/^$/
find -L $rvm_path/gems         -regextype posix-extended -regex '.*1.8.7-p[[:digit:]]+-ntest.*' -print -quit # match=/^$/
find -L $rvm_path/bin          -regextype posix-extended -regex '.*1.8.7-p[[:digit:]]+-ntest.*' -print -quit # match=/^$/

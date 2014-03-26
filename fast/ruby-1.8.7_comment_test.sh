source "$rvm_path/scripts/rvm"

rvm remove  1.8.7-p374-ntest --gems

## without gemsets

rvm install 1.8.7-p374-ntest --skip-gemsets
# status=0
# match!=/Already installed/
# match=/[Aa]pplying patch/
# match=/Skipped importing default gemsets/
# match=/WARNING: Please be aware that you just installed a ruby that/
# match=/for a list of maintained rubies visit:/

rvm install 1.8.7-p374-ntest
# status=0; match=/Already installed/

rvm 1.8.7-p374-ntest do which gem
# match=/1.8.7-p[[:digit:]]+-ntest/

rvm 1.8.7-p374-ntest do gem env

rvm 1.8.7-p374-ntest do gem list
# match[stderr]=/\A\Z/
# match[stdout]!=/bundler/
# match[stdout]!=/rake/
# match[stdout]!=/rubygems-bundler/
# match[stdout]!=/rvm/

rvm 1.8.7-p374-ntest do ruby -v
# match=/1.8.7/

rvm remove  1.8.7-p374-ntest --gems
# status=0; match=/[Rr]emoving/


## default/global gemsets

mkdir -p $rvm_path/gemsets/ruby/1.8.7/
printf "gem-wrappers\nhaml\n" > $rvm_path/gemsets/ruby/1.8.7/default.gems
printf "gem-wrappers\ntf\n"   > $rvm_path/gemsets/ruby/1.8.7/global.gems

rvm install 1.8.7-p374-ntest
# status=0
# match!=/Already installed/
# match=/[Aa]pplying patch/
# match=/importing.*gemset/
# match=/WARNING: Please be aware that you just installed a ruby that/
# match=/for a list of maintained rubies visit:/

rvm 1.8.7-p374-ntest do gem list
# match[stderr]=/\A\Z/
# match[stdout]=/haml/
# match[stdout]=/tf/

rvm 1.8.7-p374-ntest@global do gem list
# match[stderr]=/\A\Z/
# match[stdout]!=/haml/
# match[stdout]=/tf/

## Cleanup

rvm remove 1.8.7-p374-ntest --gems
# status=0; match=/[Rr]emoving/

rm -rf $rvm_path/gemsets/ruby/1.8.7/

find -L $rvm_path/environments -name '*1.8.7-p374-ntest*' -print -quit # match=/^$/
find -L $rvm_path/wrappers     -name '*1.8.7-p374-ntest*' -print -quit # match=/^$/
find -L $rvm_path/gems         -name '*1.8.7-p374-ntest*' -print -quit # match=/^$/
find -L $rvm_path/bin          -name '*1.8.7-p374-ntest*' -print -quit # match=/^$/

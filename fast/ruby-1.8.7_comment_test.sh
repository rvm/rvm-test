source "$rvm_path/scripts/rvm"

rvm remove  2.1.1-ntest --gems

## without gemsets

rvm install 2.1.1-ntest --skip-gemsets
# status=0
# match!=/Already installed/
# match=/[Aa]pplying patch/
# match=/Skipped importing default gemsets/
# match=/WARNING: Please be aware that you just installed a ruby that/
# match=/for a list of maintained rubies visit:/

rvm install 2.1.1-ntest
# status=0; match=/Already installed/

rvm 2.1.1-ntest do which gem
# match=/2.1.1-ntest/

rvm 2.1.1-ntest do gem env

rvm 2.1.1-ntest do gem list
# match[stderr]=/\A\Z/
# match[stdout]!=/bundler/
# match[stdout]!=/rake/
# match[stdout]!=/rubygems-bundler/
# match[stdout]!=/rvm/

rvm 2.1.1-ntest do ruby -v
# match=/2.1.1/

rvm remove  2.1.1-ntest --gems
# status=0; match=/[Rr]emoving/


## default/global gemsets

mkdir -p $rvm_path/gemsets/ruby/2.1.1/
printf "gem-wrappers\nhaml\n" > $rvm_path/gemsets/ruby/2.1.1/default.gems
printf "gem-wrappers\ntf\n"   > $rvm_path/gemsets/ruby/2.1.1/global.gems

rvm install 2.1.1-ntest
# status=0
# match!=/Already installed/
# match=/[Aa]pplying patch/
# match=/importing.*gemset/
# match=/WARNING: Please be aware that you just installed a ruby that/
# match=/for a list of maintained rubies visit:/

rvm 2.1.1-ntest do gem list
# match[stderr]=/\A\Z/
# match[stdout]=/haml/
# match[stdout]=/tf/

rvm 2.1.1-ntest@global do gem list
# match[stderr]=/\A\Z/
# match[stdout]!=/haml/
# match[stdout]=/tf/

## Cleanup

rvm remove 2.1.1-ntest --gems
# status=0; match=/[Rr]emoving/

rm -rf $rvm_path/gemsets/ruby/2.1.1/

find -L $rvm_path/environments -name '*2.1.1-ntest*' -print -quit # match=/^$/
find -L $rvm_path/wrappers     -name '*2.1.1-ntest*' -print -quit # match=/^$/
find -L $rvm_path/gems         -name '*2.1.1-ntest*' -print -quit # match=/^$/
find -L $rvm_path/bin          -name '*2.1.1-ntest*' -print -quit # match=/^$/

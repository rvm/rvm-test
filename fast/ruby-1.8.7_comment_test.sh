source "$rvm_path/scripts/rvm"

rvm reinstall 1.8.7-ntest      # status=0
# match!=/Already installed/
# match=/Applying patch/
# match=/patches just to be compiled on/
rvm 1.8.7-ntest do ruby -v     # match=/1.8.7/
rvm install 1.8.7-ntest        # status=0; match=/Already installed/
rvm remove 1.8.7-ntest         # status=0; match=/Removing/
rvm install ruby-1.8.7 --skip-gemsets # status=0; match=/Skipped importing default gemsets/

source "$rvm_path/scripts/rvm"
rvm use 1.8.7
gem list
# match!=/rvm/
# match!=/rubygems-bundler/
# match!=/bundler/
# match!=/rake/

: reset
rvm remove 1.8.7

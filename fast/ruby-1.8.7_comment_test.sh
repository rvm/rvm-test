source "$rvm_path/scripts/rvm"

rvm reinstall 1.8.7-ntest --skip-gemsets
# status=0
# match!=/Already installed/
# match=/Applying patch/
# match=/Skipped importing default gemsets/
# match=/patches just to be compiled on/
rvm 1.8.7-ntest do gem list
# match!=/bundler/
# match!=/rake/
# match!=/rubygems-bundler/
# match!=/rvm/
rvm 1.8.7-ntest do ruby -v    # match=/1.8.7/
rvm install 1.8.7-ntest       # status=0; match=/Already installed/
rvm remove 1.8.7-ntest --gems # status=0; match=/Removing/

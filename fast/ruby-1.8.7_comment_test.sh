source "$rvm_path/scripts/rvm"

rvm reinstall 1.8.7-ntest      # status=0; match!=/Already installed/; match=/Applying patch/
rvm 1.8.7-ntest do ruby -v     # match=/1.8.7/
rvm install 1.8.7-ntest        # status=0; match=/Already installed/
rvm remove 1.8.7-ntest         # status=0; match=/Removing/

source "$rvm_path/scripts/rvm"

rvm use 2.1.1 --install

rvm env 2.1.1           # match=/2.1.1/; match=/GEM_HOME=/; match=/GEM_PATH=/
rvm env 2.1.1 --path    # match=/2.1.1/; match=/environments/
rvm env 2.1.1 -- --path # match=/2.1.1/; match=/environments/

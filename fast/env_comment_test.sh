source "$rvm_path/scripts/rvm"

rvm use 1.8.7-p374 --install

rvm env 1.8.7-p374           # match=/1.8.7-p374/; match=/GEM_HOME=/; match=/GEM_PATH=/
rvm env 1.8.7-p374 --path    # match=/1.8.7-p374/; match=/environments/
rvm env 1.8.7-p374 -- --path # match=/1.8.7-p374/; match=/environments/

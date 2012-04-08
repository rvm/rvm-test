source "$rvm_path/scripts/rvm"

rvm use 1.8.7-p358 --install

rvm env 1.8.7-p358           # match=/1.8.7-p358/; match=/GEM_HOME=/; match=/GEM_PATH=/
rvm env 1.8.7-p358 --path    # match=/1.8.7-p358/; match=/environments/
rvm env 1.8.7-p358 -- --path # match=/1.8.7-p358/; match=/environments/

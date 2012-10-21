rvm get head # status=0 ; match=/Downloading RVM from wayneeseguin branch master/; match=/RVM reloaded/
rvm use 1.9.3-p286 --install # status=0
rvm use 1.9.3-p194 --install # status=0
rvm --force gemset globalcache disable
rvm gemset globalcache enabled # status=1; match=/ Disabled/
rvm gemset globalcache enable # status=0; match=/ global cache /
rvm gemset globalcache enabled # status=0; match=/ Enabled/
rvm gemset list # status=0; match=/ global$/
rvm gemset export 1.9.3-p194@global  193-p194-global.gems # status=0; match=/Exporting current environments gemset/
rvm gemset export 1.9.3-p286@global  193-p286-global.gems # status=0; match=/Exporting current environments gemset/
rvm gemset empty 1.9.3-p286@global  --force # status=0
rvm --trace gemset copy 1.9.3-p194@global 1.9.3-p286@global # status=0; match=/Copying gemset/; match!=/Unknown file type/; match!=/cannot overwrite directory/; match!=/with non-directory/; match!=/Error running/
rvm 1.9.3-p286@global do bash -c 'GEM_PATH=$GEM_DIR gem list' # status=0; match=/rvm/
rvm gemset --force empty 1.9.3-p286@global # status=0
rvm get master # status=0 ; match=/RVM reloaded/

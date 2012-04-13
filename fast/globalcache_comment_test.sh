source "$rvm_path/scripts/rvm"

rvm use 1.9.3 --install                           # status=0

grep globalcache "$rvm_path/user/db"              # status=1

[[ -L "$rvm_path/gems/cache" ]]                   # status=1

rvm gemset globalcache enable                     # status=0; match=/ global cache /
rvm gemset list                                   # status=0; match!=/ testset /

rvm 1.9.3 do rvm gemset create testset            # status=0; match=/ gemset created /

[[ -L "$rvm_path/gems/cache" ]]                   # status=1
[[ -d "$rvm_path/gems/cache" ]]                   # status=0

rvm system                                        # status=0

[[ -L "$rvm_path/gems/cache" ]]                   # status=1
[[ -d "$rvm_path/gems/cache" ]]                   # status=0

[[ -L "$rvm_path/gems/cache" ]] && rm -f "$rvm_path/gems/cache"

rvm --force gemset globalcache disable            # status=0; match=/Removing the global cache/


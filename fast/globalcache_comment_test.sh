source "$rvm_path/scripts/rvm"

rvm use 1.9.3 --install                           # status=0
rvm --force gemset globalcache disable
rvm gemset globalcache enabled                    # match=/Disabled/

[[ -L "$rvm_path/gems/cache" ]]                   # status!=0

rvm gemset globalcache enable                     # status=0; match=/ global cache /
rvm gemset globalcache enabled                    # status=0; match=/Enabled/
rvm gemset list                                   # status=0; match!=/ testset /

rvm 1.9.3 do rvm gemset create testset            # status=0; match=/ gemset created /

[[ -L "$rvm_path/gems/cache" ]]                   # status!=0
[[ -d "$rvm_path/gems/cache" ]]                   # status=0

rvm system                                        # status=0

[[ -L "$rvm_path/gems/cache" ]]                   # status!=0
[[ -d "$rvm_path/gems/cache" ]]                   # status=0
[[ -d "$rvm_path/gems/cache/cache" ]]             ## status!=0 ... need more testing for this

rvm --force gemset globalcache disable            # status=0;  match=/Removing the global cache/
rvm gemset globalcache enabled                    # status!=0; match=/Disabled/

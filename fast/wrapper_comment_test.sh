source "$rvm_path/scripts/rvm"

iv=1.8.7         ## installed ruby version (we'll ensure it's installed)
nv=1.2.3         ## non-existent ruby version
ivp=$iv-p352     ## installed ruby version and patchlevel
ivnp=$iv-p999    ## installed ruby version but invalid patchlevel
nvp=$nv-p999     ## non-existent ruby version and patchlevel

bdir="$rvm_path/bin"

rvm install $ivp # status=0

: help
rvm wrapper      # status!=0; match=/Usage/

: non-existent version
rvm wrapper $nv                           # status!=0; match=/Could not load ruby .*1\.2\.3/
[[ -f $rvm_path/wrappers/ruby-$nvp/erb ]] # status!=0
[[ -L $bdir/erb-ruby-$nvp ]]              # status!=0
rvm wrapper $nvp                          # status!=0; match=/Could not load ruby .*1\.2\.3/
rvm wrapper $nv --no-prefix               # status!=0; match=/Could not load ruby .*1\.2\.3/
rvm wrapper $nv --no-prefix erb           # status!=0; match=/Could not load ruby .*1\.2\.3/
rvm wrapper $nv myprefix                  # status!=0; match=/Could not load ruby .*1\.2\.3/
rvm wrapper $nv myprefix erb              # status!=0; match=/Could not load ruby .*1\.2\.3/

: non-existent version and patchlevel
rvm wrapper $nvp --no-prefix              # status!=0; match=/Could not load ruby .*1\.2\.3/
rvm wrapper $nvp --no-prefix erb          # status!=0; match=/Could not load ruby .*1\.2\.3/
rvm wrapper $nvp myprefix                 # status!=0; match=/Could not load ruby .*1\.2\.3/
rvm wrapper $nvp myprefix erb             # status!=0; match=/Could not load ruby .*1\.2\.3/

: installed version, invalid patchlevel
rvm wrapper $ivnp --no-prefix             # status!=0; match=/Could not load ruby .*1\.8\.7-p999/
rvm wrapper $ivnp --no-prefix erb         # status!=0; match=/Could not load ruby .*1\.8\.7-p999/
rvm wrapper $ivnp myprefix                # status!=0; match=/Could not load ruby .*1\.8\.7-p999/
rvm wrapper $ivnp myprefix erb            # status!=0; match=/Could not load ruby .*1\.8\.7-p999/

: installed version
rvm wrapper $ivp                          # status=0; match[stderr]=/\A\Z/
readlink $bdir/erb-ruby-$ivp              # status=0; match=/1\.8\.7-p352\/erb$/
[[ -L $bdir/erb-ruby-$ivp ]]              # status=0
rm -f $bdir/ruby-$ivp                     # status=0
rm -f $bdir/{erb,gem,irb,rake,rdoc,ri,testrb}-ruby-$ivp # status=0

rvm wrapper $ivp --no-prefix              # status=0; match[stderr]=/\A\Z/
readlink $bdir/erb                        # status=0; match=/1\.8\.7-p352\/erb$/
[[ -L $bdir/erb ]]                        # status=0
rm -f $bdir/ruby-$ivp                     # status=0
rm -f $bdir/{erb,gem,irb,rake,rdoc,ri,ruby,testrb} # status=0

rvm wrapper $ivp myprefix                 # status=0; match[stderr]=/\A\Z/
readlink $bdir/myprefix_erb               # status=0; match=/1\.8\.7-p352\/erb$/
[[ -L $bdir/myprefix_erb ]]               # status=0
rm -f $bdir/myprefix_ruby-$ivp            # status=0
rm -f $bdir/myprefix_{erb,gem,irb,rake,rdoc,ri,ruby,testrb} # status=0

: installed version, single binary
rvm wrapper $ivp --no-prefix erb          # status=0; match[stderr]=/\A\Z/
readlink $bdir/erb                        # status=0; match=/1\.8\.7-p352\/erb$/
[[ -L $bdir/erb ]]                        # status=0
[[ -e $bdir/rake-ruby-$ivp ]]             # status!=0
[[ -e $bdir/ruby-$ivp ]]                  # status!=0
rm -f $bdir/erb-ruby-$ivp                 # status=0

rvm wrapper $ivp myprefix erb             # status=0; match[stderr]=/\A\Z/
readlink $bdir/myprefix_erb               # status=0; match=/1\.8\.7-p352\/erb$/
[[ -L $bdir/myprefix_erb ]]               # status=0
[[ -e $bdir/myprefix_rake-ruby-$ivp ]]    # status!=0
[[ -e $bdir/myprefix_ruby-$ivp ]]         # status!=0
rm -f $bdir/erb-ruby-$ivp                 # status=0

: installed version, multiple binaries
rvm wrapper $ivp --no-prefix erb irb      # status=0; match[stderr]=/\A\Z/
readlink $bdir/erb                        # status=0; match=/1\.8\.7-p352\/erb$/
readlink $bdir/irb                        # status=0; match=/1\.8\.7-p352\/irb$/
[[ -L $bdir/erb ]]                        # status=0
[[ -L $bdir/irb ]]                        # status=0
[[ -e $bdir/rake-ruby-$ivp ]]             # status!=0
[[ -e $bdir/ruby-$ivp ]]                  # status!=0
rm -f $bdir/{erb,irb}-ruby-$ivp           # status=0

rvm wrapper $ivp myprefix erb irb         # status=0; match[stderr]=/\A\Z/
readlink $bdir/myprefix_erb               # status=0; match=/1\.8\.7-p352\/erb$/
readlink $bdir/myprefix_irb               # status=0; match=/1\.8\.7-p352\/irb$/
[[ -L $bdir/myprefix_erb ]]               # status=0
[[ -L $bdir/myprefix_irb ]]               # status=0
[[ -e $bdir/myprefix_rake-ruby-$ivp ]]    # status!=0
[[ -e $bdir/myprefix_ruby-$ivp ]]         # status!=0
rm -f $bdir/myprefix_{erb,irb}-ruby-$ivp  # status=0

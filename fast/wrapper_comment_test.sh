source "$rvm_path/scripts/rvm"

iv=1.9.1         ## installed ruby version (we'll ensure it's installed)
nv=1.2.3         ## non-existent ruby version
ivp=$iv-p431     ## installed ruby version and patchlevel
ivnp=$iv-p999    ## installed ruby version but invalid patchlevel
nvp=$nv-p999     ## non-existent ruby version and patchlevel

wdir="$rvm_path/wrappers/ruby-$ivp"

rvm install $ivp

: insufficient parameters
rvm wrapper                          # status!=0; match=/Not enough parameters/
rvm wrapper $nv                      # status!=0; match=/Not enough parameters/
rvm wrapper $nvp                     # status!=0; match=/Not enough parameters/
rvm wrapper $iv                      # status!=0; match=/Not enough parameters/
rvm wrapper $ivp                     # status!=0; match=/Not enough parameters/

: non-existent version
rvm wrapper $nv --no-prefix          # status!=0; match=/Could not load ruby .*1\.2\.3/
rvm wrapper $nv --no-prefix erb      # status!=0; match=/Could not load ruby .*1\.2\.3/
rvm wrapper $nv myprefix             # status!=0; match=/Could not load ruby .*1\.2\.3/
rvm wrapper $nv myprefix erb         # status!=0; match=/Could not load ruby .*1\.2\.3/

: non-existent version and patchlevel
rvm wrapper $nvp --no-prefix         # status!=0; match=/Could not load ruby .*1\.2\.3/
rvm wrapper $nvp --no-prefix erb     # status!=0; match=/Could not load ruby .*1\.2\.3/
rvm wrapper $nvp myprefix            # status!=0; match=/Could not load ruby .*1\.2\.3/
rvm wrapper $nvp myprefix erb        # status!=0; match=/Could not load ruby .*1\.2\.3/

: installed version, invalid patchlevel
rvm wrapper $ivnp --no-prefix        # status!=0; match=/Could not load ruby .*1\.9\.1-p999/
rvm wrapper $ivnp --no-prefix erb    # status!=0; match=/Could not load ruby .*1\.9\.1-p999/
rvm wrapper $ivnp myprefix           # status!=0; match=/Could not load ruby .*1\.9\.1-p999/
rvm wrapper $ivnp myprefix erb       # status!=0; match=/Could not load ruby .*1\.9\.1-p999/

: installed version
rvm wrapper $iv --no-prefix          # status=0;  match=/\A\Z/
rm $wdir/{erb,gem,irb,rake,rdoc,ri,ruby,testrb} 
                                     # status=0
rvm wrapper $iv myprefix             # status=0;  match=/\A\Z/
rm $wdir/myprefix-{erb,gem,irb,rake,rdoc,ri,ruby,testrb} 
                                     # status=0

: installed version and patchlevel
rvm wrapper $ivp --no-prefix         # status=0;  match=/\A\Z/
rm $wdir/{erb,gem,irb,rake,rdoc,ri,ruby,testrb} 
                                     # status=0
rvm wrapper $ivp myprefix            # status=0;  match=/\A\Z/
rm $wdir/myprefix-{erb,gem,irb,rake,rdoc,ri,ruby,testrb} 
                                     # status=0

: installed version, single binary
rvm wrapper $iv --no-prefix erb      # status=0;  match=/\A\Z/
rm $wdir/erb                         # status=0
[[ -e $wdir/rake ]]                  # status!=0
rvm wrapper $iv myprefix erb         # status=0;  match=/\A\Z/
rm $wdir/myprefix-erb                # status=0
[[ -e $wdir/myprefix-rake ]]         # status!=0

: installed version and patchlevel, single binary
rvm wrapper $ivp --no-prefix erb     # status=0;  match=/\A\Z/
rm $wdir/erb                         # status=0
[[ -e $wdir/rake ]]                  # status!=0
rvm wrapper $ivp myprefix erb        # status=0;  match=/\A\Z/
rm $wdir/myprefix-erb                # status=0
[[ -e $wdir/myprefix-rake ]]         # status!=0

: installed version, multiple binaries
rvm wrapper $iv --no-prefix erb irb  # status=0;  match=/\A\Z/
rm $wdir/{erb,irb}                   # status=0
[[ -e $wdir/rake ]]                  # status!=0
rvm wrapper $iv myprefix erb irb     # status=0;  match=/\A\Z/
rm $wdir/myprefix-{erb,irb}          # status=0
[[ -e $wdir/myprefix-rake ]]         # status!=0

: installed version and patchlevel, multiple binaries
rvm wrapper $ivp --no-prefix erb irb # status=0;  match=/\A\Z/
rm $wdir/{erb,irb}                   # status=0
[[ -e $wdir/rake ]]                  # status!=0
rvm wrapper $ivp myprefix erb irb    # status=0;  match=/\A\Z/
rm $wdir/myprefix-{erb,irb}          # status=0
[[ -e $wdir/myprefix-rake ]]         # status!=0

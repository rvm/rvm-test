source "$rvm_path/scripts/rvm"

rvm use 1.8.7 --install # status=0
rvm gemset create test1 # status=0
rvm gemset create test2 # status=0
rvm use 1.9.3 --install # status=0

: do
rvm 9.9.9 do rvm gemdir # status=1; match=/is not installed/
rvm 1.8.7 do rvm gemdir # status=0; match=/1.8.7-p[[:digit:]]+/
rvm 1.8.7@test0 do rvm gemdir # status=2; match=/Gemset .* does not exist/
rvm 1.8.7@test1 do rvm gemdir # status=0; match=/1.8.7-p[[:digit:]]+@test1/
rvm 1.8.7@test2 do rvm gemdir # status=0; match=/1.8.7-p[[:digit:]]+@test2/

rvm 1.8.7@global,1.8.7 do rvm gemdir # status=0; match=/1.8.7-p[[:digit:]]+@global$/; match=/1.8.7-p[[:digit:]]+$/

rvm --force gemset delete test1 # status=0
rvm --force gemset delete test2 # status=0

: FIXME: The following tests have awful duplication due to https://github.com/mpapis/tf/issues/6

: -----------------------------------------------------------------
: do in directory with no version

true TMPDIR:${TMPDIR:=/tmp}:
d=$TMPDIR/test-rvm-do-in
mkdir -p $d

: absolute directory
rvm in $d do rvm info ruby  # status=1; match=/Could not determine which Ruby to use/
rvm in $d do ruby --version # status=1; match=/Could not determine which Ruby to use/

: relative directory
cd $TMPDIR
rvm in test-rvm-do-in do rvm info ruby  # status=1; match=/Could not determine which Ruby to use/
rvm in test-rvm-do-in do ruby --version # status=1; match=/Could not determine which Ruby to use/

: current directory
cd $d
rvm in . do rvm info ruby  # status=1; match=/Could not determine which Ruby to use/
rvm in . do ruby --version # status=1; match=/Could not determine which Ruby to use/
rvm    . do rvm info ruby  # status=1; match=/Could not determine which Ruby to use/
rvm    . do ruby --version # status=1; match=/Could not determine which Ruby to use/

: -----------------------------------------------------------------
mkdir -p $d/1.8.7
echo "1.8.7" > $d/1.8.7/.ruby-version

: absolute directory
rvm in $d/1.8.7 do rvm info ruby  # status=0; match=/version: *"1.8.7/
rvm in $d/1.8.7 do ruby --version # status=0; match=/^ruby 1.8.7 /

: relative directory
cd $d
rvm in 1.8.7 do rvm info ruby  # status=0; match=/version: *"1.8.7/
rvm in 1.8.7 do ruby --version # status=0; match=/^ruby 1.8.7 /

: current directory
cd $d/1.8.7
rvm . do rvm info ruby  # status=0; match=/version: *"1.8.7/
rvm . do ruby --version # status=0; match=/^ruby 1.8.7 /

: -----------------------------------------------------------------
ver=1.9.3
mkdir -p $d/1.9.3
echo "1.9.3" > $d/1.9.3/.ruby-version

: absolute directory
rvm in $d/1.9.3 do rvm info ruby  # status=0; match=/version: *"1.9.3/
rvm in $d/1.9.3 do ruby --version # status=0; match=/^ruby 1.9.3p/

: relative directory
cd $d
rvm in 1.9.3 do rvm info ruby  # status=0; match=/version: *"1.9.3/
rvm in 1.9.3 do ruby --version # status=0; match=/^ruby 1.9.3p/

: current directory
cd $d/1.9.3
rvm . do rvm info ruby  # status=0; match=/version: *"1.9.3/
rvm . do ruby --version # status=0; match=/^ruby 1.9.3p/

## cleanup
rm -rf $d

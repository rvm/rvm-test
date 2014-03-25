source "$rvm_path/scripts/rvm"

: prepare
true TMPDIR:${TMPDIR:=/tmp}:
d=$TMPDIR/test-remote
mkdir $d
pushd $d
rvm use 1.9.3-p484 --install # status=0
rvm list
# match=/ruby-1.9.3-p484/

: tast packaging
rvm prepare 1.9.3-p484           # status=0
[[ -f ruby-1.9.3-p484.tar.bz2 ]] # status=0

: remove it
rvm remove --gems 1.9.3-p484     # status=0
rvm list
# match!=/ruby-1.9.3-p484/

: get local ruby
rvm mount -r ruby-1.9.3-p484.tar.bz2 # status=0
rvm list
# match=/ruby-1.9.3-p484/
rvm use 1.9.3-p484 # status=0; match[stderr]=/^$/

: clean
popd
rm -rf $d

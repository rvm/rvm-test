source "$rvm_path/scripts/rvm"

: prepare
true TMPDIR:${TMPDIR:=/tmp}:
d=$TMPDIR/test-rvmrc
mkdir $d
pushd $d
rvm use 1.8.7

: .rvmrc
rvm rvmrc create 1.9.3
rvm rvmrc trust .
[ -f .rvmrc ] # status=0
rvm current   # match=/1.8.7/
cd .
rvm current   # match=/1.9.3/

rm -f .rvmrc
rvm use 1.8.7

: .versions.conf
rvm rvmrc create 1.9.3 .versions.conf
[ -f .versions.conf ] # status=0
rvm current           # match=/1.8.7/
cd .
rvm current           # match=/1.9.3/

rm -f .versions.conf
rvm use 1.8.7

: .ruby-version
rvm rvmrc create 1.9.3 .ruby-version
[ -f .ruby-version ] # status=0
rvm current          # match=/1.8.7/
cd .
rvm current          # match=/1.9.3/

rm -f .ruby-version
rvm use 1.8.7

: clean
popd
rm -rf $d

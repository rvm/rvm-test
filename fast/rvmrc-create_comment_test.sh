source "$rvm_path/scripts/rvm"

: prepare
true TMPDIR:${TMPDIR:=/tmp}:
d=$TMPDIR/test-rvmrc
mkdir $d
pushd $d
command rvm install 2.1.2
rvm 2.1.2 do rvm gemset reset_env
rvm use 2.1.0 --install

: .rvmrc generated
rvm rvmrc create 2.1.2
[ -f .rvmrc ]         # status=0
rvm current           # match=/2.1.0/
rvm rvmrc trust .rvmrc
rvm rvmrc load .rvmrc # env[GEM_HOME]=/2.1.2$/ ; env[PATH]=/2.1.2/
rvm current           # match=/2.1.1/

: .rvmrc with use
rvm_current_rvmrc=""
echo "rvm use 2.1.0" > .rvmrc
rvm rvmrc trust .
rvm rvmrc load .
rvm current           # match=/2.1.0/

: .rvmrc without use
rvm_current_rvmrc=""
echo "rvm 2.1.1" > .rvmrc
rvm rvmrc trust
rvm rvmrc load
rvm current           # match=/2.1.1/

rm -f .rvmrc
rvm use 2.1.0

: .versions.conf
rvm rvmrc create 2.1.1 .versions.conf
[ -f .versions.conf ] # status=0
rvm current           # match=/2.1.0/
rvm rvmrc load .
rvm current           # match=/2.1.1/

rm -f .versions.conf
rvm use 2.1.0

: .ruby-version
rvm rvmrc create 2.1.1 .ruby-version
[ -f .ruby-version ]  # status=0
rvm current           # match=/2.1.0/
rvm rvmrc load .
rvm current           # match=/2.1.1/

rm -f .ruby-version
rvm use 2.1.0

: clean
popd
rm -rf $d

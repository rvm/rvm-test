source "$rvm_path/scripts/rvm"

: prepare
true TMPDIR:${TMPDIR:=/tmp}:
d=$TMPDIR/test-ruby-version
f=$d/.ruby-version
g=$d/.ruby-gemset
mkdir -p $d
cd $d
rvm use --install 1.9.3-p484
rvm use --install 1.9.3
rvm use --install 1.8.7

## simple
: short version
echo "1.9.3" > $f           # env[GEM_HOME]=/1.8.7/
rvm use .                   # env[GEM_HOME]=/1.9.3/

: ruby version
rvm use 1.8.7
echo "ruby-1.9.3" > $f      # env[GEM_HOME]=/1.8.7/
rvm use .                   # env[GEM_HOME]=/1.9.3/

: patch version
rvm use 1.8.7
echo "1.9.3-p484" > $f      # env[GEM_HOME]=/1.8.7/
rvm use .                   # env[GEM_HOME]=/1.9.3-p484/

: full version
rvm use 1.8.7
echo "ruby-1.9.3-p484" > $f # env[GEM_HOME]=/1.8.7/
rvm use .                   # env[GEM_HOME]=/1.9.3-p484/

: gemset
rvm use 1.8.7
echo "veve" > $g            # env[GEM_HOME]=/1.8.7/
rvm use .                   # env[GEM_HOME]=/1.9.3-p484@veve/

: clean
cd ..
rm -rf $d

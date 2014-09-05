source "$rvm_path/scripts/rvm"

: prepare
true TMPDIR:${TMPDIR:=/tmp}:
d=$TMPDIR/test-ruby-version
f=$d/.ruby-version
g=$d/.ruby-gemset
mkdir -p $d
cd $d
rvm use --install 2.1.2
rvm use --install 2.1.1
rvm use --install 2.1.0

## simple
: short version
echo "2.1.1" > $f           # env[GEM_HOME]=/2.1.0/
rvm use .                   # env[GEM_HOME]=/2.1.1/

: ruby version
rvm use 2.1.0
echo "ruby-2.1.1" > $f      # env[GEM_HOME]=/2.1.0/
rvm use .                   # env[GEM_HOME]=/2.1.1/

: patch version
rvm use 2.1.0
echo "2.1.2" > $f      # env[GEM_HOME]=/2.1.0/
rvm use .                   # env[GEM_HOME]=/2.1.2/

: full version
rvm use 2.1.0
echo "ruby-2.1.2" > $f # env[GEM_HOME]=/2.1.0/
rvm use .                   # env[GEM_HOME]=/2.1.2/

: gemset
rvm use 2.1.0
echo "veve" > $g            # env[GEM_HOME]=/2.1.0/
rvm use .                   # env[GEM_HOME]=/2.1.2@veve/

: clean
cd ..
rm -rf $d

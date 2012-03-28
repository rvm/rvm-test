source "$rvm_path/scripts/rvm"

: prepare
true TMPDIR:${TMPDIR:=/tmp}:
d=$TMPDIR/test-versions-conf
mcd(){ mkdir -p $1 ; cd $1 ; }

: generate
mcd $d/a
rvm use 1.9.3@versions-conf-a --create --versions-conf
[[ -f .versions.conf ]] # status=0

mcd $d/b
rvm use 1.8.7@versions-conf-b --create --versions-conf
[[ -f .versions.conf ]] # status=0

: test
mcd $d/a
rvm current # match=/^ruby-1.9.3-.*@versions-conf-a$/
mcd $d/b
rvm current # match=/^ruby-1.8.7-.*@versions-conf-b$/

: test installing gem
mcd $d/a
gem list # match!=/haml/
echo "ruby-gem-install=haml" >> .versions.conf
cd .     # match!=/moving aside to preserve/
gem list # match=/haml/

: test bundler
mcd $d/b
gem list # match!=/haml/
printf "ruby-gem-install=bundler\nruby-bundle-install=true\n" >> .versions.conf
printf "source :rubygems\n\ngem 'haml'\n" > Gemfile
cd .
gem list # match=/haml/; match=/bundler/

: clean
rvm 1.9.3 do rvm --force gemset delete versions-conf-a
rvm 1.8.7 do rvm --force gemset delete versions-conf-b
rm -rf $d

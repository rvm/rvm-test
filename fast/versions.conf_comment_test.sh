rvm_reload_flag=1 source "$rvm_path/scripts/rvm"

: prepare
true TMPDIR:${TMPDIR:=/tmp}:
d=$TMPDIR/test-versions-conf
mcd(){ mkdir -p $1 ; cd $1 ; }
mcd $d
rm -f */*

: generate
mcd $d/a
rvm use 1.9.3@versions-conf-a --create --versions-conf
rvm current             # match=/^ruby-1.9.3-.*@versions-conf-a$/
[[ -f .versions.conf ]] # status=0

mcd $d/b
rvm use 1.8.7@versions-conf-b --create --versions-conf
rvm current             # match=/^ruby-1.8.7-.*@versions-conf-b$/
[[ -f .versions.conf ]] # status=0

: test
rvm rvmrc load $d/a
rvm current         # match=/^ruby-1.9.3-.*@versions-conf-a$/
rvm rvmrc load $d/b
rvm current         # match=/^ruby-1.8.7-.*@versions-conf-b$/

: test installing gem
mcd $d/a
gem list         # match!=/haml/
echo "ruby-gem-install=haml" >> .versions.conf
rvm_current_rvmrc=""
rvm rvmrc load . # match!=/moving aside to preserve/; match=/Successfully installed haml/
gem list         # match=/haml/

: test bundler
mcd $d/b
gem list # match!=/haml/
printf "ruby-gem-install=bundler\nruby-bundle-install=true\n" >> .versions.conf
printf "source :rubygems\n\ngem 'haml'\n" > Gemfile
rvm_current_rvmrc=""
rvm rvmrc load . # match=/Installing haml/
gem list # match=/haml/; match=/bundler/

: clean
rvm 1.9.3 do rvm --force gemset delete versions-conf-a
rvm 1.8.7 do rvm --force gemset delete versions-conf-b
rm -rf $d

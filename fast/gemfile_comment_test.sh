source "$rvm_path/scripts/rvm"

: settings
true TMPDIR:${TMPDIR:=/tmp}:
d=$TMPDIR/test-rvmrc
f_rvmrc=$d/.rvmrc
f_gemfile=$d/sub/Gemfile

: prepare1
rvm use 1.9.3 --install
mkdir -p $d/sub
printf "rvm use 1.9.3@rvmrc --create\n"   > $f_rvmrc

: test1
rvm current           # match!=/^ruby-1.9.3-p[[:digit:]]+@rvmrc$/
rvm rvmrc load $d/sub # status=0; match=/Using .*ruby-1.9.3-p[[:digit:]]+.*rvmrc/
rvm current           # match=/^ruby-1.9.3-p[[:digit:]]+@rvmrc$/

: prepare2
rvm use 1.9.3 --install
printf "source :rubygems\n\ngem 'haml'\n" > $f_gemfile

: test2
rvm current           # match!=/^ruby-1.9.3-p[[:digit:]]+@rvmrc$/
rvm rvmrc load $d/sub # status=0; match=/Using .*ruby-1.9.3-p[[:digit:]]+.*rvmrc/
rvm current           # match=/^ruby-1.9.3-p[[:digit:]]+@rvmrc$/

: clean
rvm 1.9.3 do rvm --force gemset delete rvmrc
rm -rf $d

source "$rvm_path/scripts/rvm"

: settings
true TMPDIR:${TMPDIR:=/tmp}:
d=$TMPDIR/test-rvmrc
f_rvmrc=$d/.rvmrc
f_gemfile=$d/sub/Gemfile

: prepare1
rvm use 1.9.3 --install
rvm gemset create gemfile
rvm gemset create rvmrc
mkdir -p $d/sub
printf "rvm use 1.9.3@rvmrc\n"   > $f_rvmrc

: test1
rvm current           # match=/^ruby-1.9.3-p[[:digit:]]+$/
rvm_current_rvmrc=""
rvm rvmrc load $d/sub # status=0; match=/Using .*ruby-1.9.3-p[[:digit:]]+.*rvmrc/
rvm current           # match=/^ruby-1.9.3-p[[:digit:]]+@rvmrc$/

: prepare2
rvm use 1.9.3
printf "source :rubygems\n\ngem 'haml'\n" > $f_gemfile

: test2
rvm current           # match=/^ruby-1.9.3-p[[:digit:]]+$/
rvm_current_rvmrc=""
rvm rvmrc load $d/sub # status=0; match=/Using .*ruby-1.9.3-p[[:digit:]]+.*rvmrc/
rvm current           # match=/^ruby-1.9.3-p[[:digit:]]+@rvmrc$/

: prepare3
rvm use 1.9.3
## escape # -> \x23
printf "source :rubygems\n\x23ruby=1.9.3\n\x23ruby-gemset=gemfile\ngem 'haml'\n" > $f_gemfile

: test3
rvm current           # match=/^ruby-1.9.3-p[[:digit:]]+$/
rvm_current_rvmrc=""
rvm rvmrc load $d/sub # status=0; match!=/Using .*ruby-1.9.3-p[[:digit:]]+.*rvmrc/
rvm current           # match=/^ruby-1.9.3-p[[:digit:]]+@gemfile$/

: clean
rvm use 1.9.3
rvm --force gemset delete gemfile
rvm --force gemset delete rvmrc
rm -rf $d

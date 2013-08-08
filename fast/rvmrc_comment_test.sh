source "$rvm_path/scripts/rvm"
rvm_project_rvmrc=cd source "$rvm_path/scripts/cd"

: prepare
true TMPDIR:${TMPDIR:=/tmp}:
d=$TMPDIR/test-rvmrc
f=$d/.rvmrc
mkdir -p $d
echo "echo loading-rvmrc" > $f

## simple
: trust
rvm rvmrc trust $d     # match=/ as trusted$/
rvm rvmrc trusted $d   # match=/is currently trusted/

: untrust
rvm rvmrc untrust $d   # match=/ as untrusted$/
rvm rvmrc trusted $d   # match=/is currently untrusted/

: reset
rvm rvmrc reset $d     # match=/^Reset/
rvm rvmrc trusted $d   # match=/contains unreviewed changes/

## spaces
ds="$d/with spaces"
mkdir -p "$ds"
echo "echo loading-rvmrc" > "$ds/.rvmrc"
rvm rvmrc trust "$ds"     # match=/ as trusted$/
rvm rvmrc trusted "$ds"   # match=/is currently trusted/
rvm rvmrc reset "$ds"     # match=/^Reset/

## brackets
ds="$d/with(brackets)"
mkdir -p "$ds"
echo "echo loading-rvmrc" > "$ds/.rvmrc"
rvm rvmrc trust "$ds"     # match=/ as trusted$/
rvm rvmrc trusted "$ds"   # match=/is currently trusted/
rvm rvmrc reset "$ds"     # match=/^Reset/

## load
export rvm_project_rvmrc_default=1
builtin cd
rvm use 1.9.3-p448 --default --install # status=0
rvm alias list            # match=/default/
rvm rvmrc load            # env[GEM_HOME]!=/^$/

: clean
rvm alias delete default
rm -rf $d

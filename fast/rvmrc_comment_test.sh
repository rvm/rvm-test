source "$rvm_path/scripts/rvm"

: prepare
true TMPDIR:${TMPDIR:=/tmp}:
d=$TMPDIR/test-rvmrc
f=$d/.rvmrc
mkdir $d
echo "echo loading-rvmrc" > $f

: trust
rvm rvmrc trust $d     # match=/ as trusted$/
rvm rvmrc trusted $d   # match=/is currently trusted/

: untrust
rvm rvmrc untrust $d   # match=/ as untrusted$/
rvm rvmrc trusted $d   # match=/is currently untrusted/

: reset
rvm rvmrc reset $d     # match=/^Reset/
rvm rvmrc trusted $d   # match=/contains unreviewed changes/

: clean
rm -rf $d

export rvm_scripts_path="$rvm_path/scripts"
source "$rvm_scripts_path/rvm"
rvm_project_rvmrc=cd source "$rvm_path/scripts/cd"

: prepare
true TMPDIR:${TMPDIR:=/tmp}:
d=$TMPDIR/test-rvmrc
f=$d/.rvmrc
mkdir -p $d
echo "echo loading-rvmrc" > $f
rvm use 2.0.0-p451 --install # status=0
rvm use 2.1.0 --install # status=0

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

: prepare for load/cd test
rvm alias create default 2.1.0
rvm alias list            # match=/default => ruby-2.1.0/
export rvm_project_rvmrc_default=1

## load default
builtin cd
rvm use 2.0.0-p451
rvm rvmrc load            # env[GEM_HOME]!=/^$/

## load ruby
cd
rvm use 2.0.0-p451
echo "rvm use 2.1.0" > "$d/.rvmrc"
rvm rvmrc trust "$d"      # match=/ as trusted$/
cd "$d"                   # env[GEM_HOME]=/2.1.0$/

## load ruby@gemset
cd
rvm use 2.0.0-p451
echo "rvm use 2.1.0@vee --create" > "$d/.rvmrc"
rvm rvmrc trust "$d"      # match=/ as trusted$/
cd "$d"                   # env[GEM_HOME]=/2.1.0@vee$/

## load @gemset
cd
rvm use 2.0.0-p451
echo "rvm use @vee --create" > "$d/.rvmrc"
rvm rvmrc trust "$d"      # match=/ as trusted$/
cd "$d"                   # env[GEM_HOME]=/2.0.0-p451@vee$/

## load @gemset after system
cd
rvm use system
echo "rvm use @vee --create" > "$d/.rvmrc"
rvm rvmrc trust "$d"      # match=/ as trusted$/
cd "$d"                   # env[GEM_HOME]=/2.1.0@vee$/

: clean
rvm alias delete default  # status=0
rm -rf $d

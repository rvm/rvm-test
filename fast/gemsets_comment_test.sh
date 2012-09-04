source "$rvm_path/scripts/rvm"

: create/delete/rename
rvm gemset create test_gemset            # status=0 ; match=/gemset created/
rvm gemset list                          # match=/test_gemset/; match!=/other_gems/
rvm gemset rename test_gemset other_gems # status=0
rvm gemset list                          # match!=/test_gemset/; match=/other_gems/
rvm --force gemset delete other_gems     # status=0
rvm gemset list                          # match!=/test_gemset/
rvm gemset create test_gemset            # status=0 ; match=/gemset created/
echo yes | rvm gemset delete test_gemset # status=0
rvm gemset list                          # match!=/test_gemset/

: export/import/use
rvm gemset create test_gemset
rvm gemset use test_gemset  # status=0 ; match=/Using /
rvm gemdir                  # match=/@test_gemset$/
gem install haml
rvm gemset export haml.gems # status=0; match=/Exporting /
[[ -f haml.gems ]]          # status=0
rvm --force gemset empty    # status=0
gem list                    # match!=/haml/
rvm gemset import haml.gems # status=0; match=/Installing /
rm haml.gems
gem list                    # match=/haml/
rvm --force gemset delete test_gemset

: use/create
rvm --force gemset delete test_gemset
rvm gemset use test_gemset --create # status=0 ; match=/Using /
rvm current                         # match=/test_gemset/
rvm --force gemset delete test_gemset

: cleanup
ls ~/.rvm/wrappers | grep test_gemset # status!=0
ls ~/.rvm/gems     | grep test_gemset # status!=0
ls -l ~/.rvm/bin   | grep test_gemset # status!=0
rvm gemset list    | grep test_gemset # status!=0

: use
rvm --force gemset delete unknown_gemset
rvm gemset use unknown_gemset # status!=0; match=/does not exist/
rvm current                   # match!=/unknown_gemset/

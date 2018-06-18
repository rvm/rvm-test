rvm reinstall truffleruby-ntest         # status=0; match!=/Already installed/; match=/compiling c-extensions/
rvm truffleruby-ntest do ruby -v        # status=0; match=/truffleruby/
rvm truffleruby-ntest do rake --version # status=0; match=/rake, version/
rvm truffleruby-ntest do ruby -ropen-uri -e 'puts open("https://rubygems.org/") { |f| f.read(1024) }'
# status=0; match=/RubyGems.org/
rvm remove truffleruby-ntest            # status=0; match=/Removing/

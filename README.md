# RVM - Tests

Set of tests for [RVM](https://github.com/wayneeseguin/rvm/).

## Usage

    $ gem install dtf # Install testing framework
    $ dtf fast/*      # Run the short tests (those are run on travis)
    $ dtf long/*      # Run the long set of tests, like installing rubies.

## Comment tests

Filenames have to end with _comment_test.sh

Example test file:

    ## User comments start with double #
    ## command can be writen in one line with multiple tests:
    true # status=0; match=/^$/
    ## or tests can be placed in following lines:
    false
    # status=1

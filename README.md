# RVM - Tests

Set of tests for [RVM](https://github.com/wayneeseguin/rvm/).

## Status

This repository is no longer used.

Instead, https://github.com/rvm/rvm includes the tests directly to facilitate changes and to ensure the full CI is run.

Please make PRs to `rvm/rvm` instead.

## Usage

    $ gem install tf    # Install testing framework
    $ tf fast/*         # Run the short tests (those are run on travis)
    $ tf long/*         # Run the long set of tests, like installing rubies.
    $ tf --text long/*  # Same as above, but watch output

## Comment tests

Filenames have to end with `_comment_test.sh`

Example test file:

    ## User comments start with double #
    ## command can be writen in one line with multiple tests:
    true # status=0; match=/^$/
    ## or tests can be placed in following lines:
    false
    # status=1

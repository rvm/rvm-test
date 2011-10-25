
This suite is designed to test everything from installation of RVM itself, to ruby installs, to gem installations.

Currently, this suite is written specifically in Ruby and Bash. However, the Ruby portion is currently the section under heavy development, and the Bash section is wonky at best.

Currently, the suite is capable of taking either a single command or a batch file that contains a series of commands to be executed, one per line. The suite currently captures the name and OS of the machine the test was run on, the timings of those commands saving a Benchmark::benchmark Tms block to the database, as well as the output of the command(s) executed. All of this is saved to a remote database server. Since the RVM Project uses a testing cluster, none of the test nodes contain their own database servers, just the the client software.

The suite currently also outputs a generic report to the screen containing all the information gathered. We utilize the concept of a 'Test Report' to which all commands executed are associated to for that specific test run.

Currently we also output a one-liner describing the last report executed on the machine that test report is associated with.

This all works, is tested, and is considered 'stable' (if somewhat messy).

To work with the suite you will need to create a database. Currently, the example_configs/ directory contains examples of the yml files for ActiveRecord. There are two of them because, since this is not a rails application, we use the standalone_migrations gem to generate the database tables. The main suite uses config/database.yml to run. All models are ActiveRecord backed. Once you have copied and edited the example config files, and placed them in the correct places, you can run the normal set of commands. Also, you need to copy the example github.rb file to config/ and populate it. The files should all either be self explanatory, or documented for format and required strings.

```shell
rake db:create && rake db:migrate
```
Should you need to reset the database, for whatever reason, do:

```shell
rake db:drop && rake db:create && rake db:migrate
```

To execute the suite, from the project root directory, you would run:

```shell
cd ruby
ruby bin/run.rb -h
```
This will show you the syntax the suite expects, which is as follows:

```shell
Usage: run.rb [-h|--help]  ['rvm command_to_run'] [-s|--script rvm_test_script]
  -h, --help	show this help message
Note: RVM command sets not in a batching file must be surrounded by '' - e.g. run.rb 'rvm info'
```
The suite is able to take either a single command, or a batch file as stated at the beginning of this document. The batch file should contain a list of commands you wish executed, one per line. The batch file can be anywhere and should be passed to the -s or --script parameter. We stick the file in batch_scripts/ for purposes of clarity, and our example is called 'testscript'.

```shell
ruby bin/run.rb --script batch_scripts/testscript
```
When the commands have finished you will see each command's output shown along with the associated Report ID and the Command ID. Do not be confused! This is the actual report detailing the information and not a double display of the output.

The suite is also able to replay previously saved sessions. To do this, you need to make sure you deploy the previous saved-session files to the db/ directory. These will usually be named db/testreport_marshalled.rvm and db/commands_marshalled.rvm for the two respective peices of each Test Report.

To replay the files, simply execute the following:

```cd ruby && ruby bin/run.rb -- --marshal```

This will reload the previous session, play it out again, and return a Completed Report gist url of that run. It should be a duplicate content-wise of the original session.


Now, go yee forth and .. Have fun with it!

--
RVM Project

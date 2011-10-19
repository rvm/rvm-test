This is the official RVM testing suite. This suite is designed to test everything from installation of RVM itself, to ruby installs, to gem installations.

Currently, this suite is written specifically in Ruby and Bash. However, the Ruby portion is currently the section under heavy development, and the Bash section is wonky at best.

Currently, the suite is capable of taking either a single command or a batch file that contains a series of commands to be executed, one per line. The suite currently captures the name and OS of the machine the test was run on, the timings of those commands saving a Benchmark::benchmark Tms block to the database, as well as the output of the command(s) executed. All of this is saved to a remote database server. Since the RVM Project uses a testing cluster, none of the test nodes contain their own database servers, just the the client software.

The suite currently also outputs a generic report to the screen containing all the information gathered. We utilize the concept of a 'Test Report' to which all commands executed are associated to for that specific test run.

Currently we also output a one-liner describing the last report executed on the machine that test report is associated with.

This all works, is tested, and is considered 'stable' (if somewhat messy).

--
RVM Project

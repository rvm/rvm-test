# Load requirements
#
# RubyGems
require 'rubygems'

# Require pry for debugging
require 'pry'
require 'pry-doc'

# Commandline options parser
require 'clint'

# Require open3 for file handling
require 'open3'
require 'session'

# ActiveRecord since models are AR backed
require 'active_record'
require 'active_support'

# Benchmarking for TestReports
require 'benchmark'
include Benchmark

# Github API interface
require 'github_api'

# Now, connect to the database using ActiveRecord
ActiveRecord::Base.establish_connection(YAML.load_file(File.dirname(__FILE__) + "/../config/database.yml"))


# Now load the Model(s).
Dir[File.dirname(__FILE__) + "/../app/models/*.rb"].each do |filename|
  # "#{filename}" == filename.to_s == filename - so just call filename
  load filename
end


# Now create both a Github and a Report object
#
# So its not in the repository, we put the bash_auth string into config/github.rb file and load it in a variable
load File.dirname(__FILE__) + "/../config/github.rb"

# You define it such as follows for a Github object
# There are other types like :oauth2, :login, etc. We just chose :basic_auth for now. See http://developer.github.com/v3/
# eg. @github = Github.new(:basic_auth => "username/token:<api_key>", :repo => "repo_name")
# @github = Github.new(:basic_auth => "deryldoucette/token:ca62f016a48adc3526be017f68e5e7b5", :repo => 'rvm-test')
# We log in via the TestReport github call because it should be the TestReport that spawns the connection, not Command.
# But, we need to instantiate the TestReport object first in order to gain access to the method/action.
#
# Currently, we are using marshalling to reload data to populate the report object.
@test_report = TestReport.new
@test_report.save!

# Remove all put and p calls when done debugging.
# There are more in the object actions themselves.
# puts "Just before load_obj_store\n"
# p @test_report.inspect
# @test_report = @test_report.load_obj_store
# puts "Outside load_obj_store\n"
# p @test_report.inspect
# p @test_report.github.inspect
# However, the above code causes a 
# bin/run.rb:54:in `<main>': undefined method `github' for #<String:0x007fae3c327700> (NoMethodError)
# This string has not changed. Are we somehow wiping out the github (or not recording it)?
@@github = @test_report.github(@login_string)


# Create a commandline parser object
cmdline = Clint.new


# Define the general usage message
cmdline.usage do
  $stderr.puts "Usage: #{File.basename(__FILE__)} [-h|--help]  ['rvm command_to_run'] [-s|--script rvm_test_script]"
end


# Define the help message
cmdline.help do
  $stderr.puts "  -h, --help\tshow this help message"
  $stderr.puts "Note: RVM commandsets not in a scriptfile must be surrounded by '' - e.g. #{File.basename(__FILE__)} 'rvm info'"
end


# Define the potential options
cmdline.options :help => false, :h => :help
cmdline.options :script => false, :s => :script
cmdline.options :marshal => false, :m => :marshal

# Parse the actual commandline arguments
cmdline.parse ARGV


# If the command options is for help, usage, or there are no arguments
# then display the help message and abort.
if cmdline.options[:help] || ARGV[0] == nil
  cmdline.help
  abort
elsif cmdline.options[:script]
    # PROCESS BATCH FILE
    # Open the script and parse. Should something go wrong with the file handler
    # display the help and abort. Wrap in a begin/rescue to handle it gracefully.
    # This executes each line storing that command's returned data in the database.
      begin
        # We call ARGV[0] here rather than ARGV[1] because the original ARGV[0] was
        # --script (or -s). when cmdline.options[:script] gets processed, it gets
        # dumped and the remaining argument(s) are shifted down in the ARGV array.
        # So now the script name is ARGV[0] rather than the normal ARGV[1]
        # We'll have to do this over and over as we keep processing deeper in the
        # options parsing if there were more options allowed / left.        

        @bash = Session::Bash.new
          File.foreach(ARGV[0]) do |cmd|
            cmd.strip!
            next if cmd =~ /^#/ or cmd.empty?
            @test_report.run_command cmd, @bash
          end
        @test_report.exit_status = @bash.status
        puts "TEST REPORT - Exit Status: #{@test_report.exit_status}"
            
        rescue Errno::ENOENT => e
          # The file wasn't found so display the help and abort.
          cmdline.help
          abort
        end
        # BATCH HAS BEEN PROCESSED
        # Now that all the commands in the batch have been processed and added to test_report,
        # now is when to save the Test Report, immediately following the processing of all commands.
        @test_report.save!
        @test_report.display_combined_gist_report
        @test_report.dump_obj_store
            
elsif cmdline.options[:marshal]
      puts "Loading and Re-executing previous session"
      @test_report.load_and_replay_obj_store
      puts "Repeat execution of previous session complete!\n"
else
  # PROCESS SINGLE COMMAND
  # All is good so onwards and upwards! This handles when just a single command,
  # not a script, is passed. Since its not a script, ARGV[0] should be the command to be run encased in ''.
  @test_report.run_command ARGV[0].strip
  @test_report.save
  @test_report.display_short_report

end

# Explicitly return 0 for success if we've made it here.
#exit 0
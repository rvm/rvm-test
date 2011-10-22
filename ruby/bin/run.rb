# Load requirements
#
# RubyGems
require 'rubygems'

# Commandline options parser
require 'clint'

# ActiveRecord since models are AR backed
require 'active_record'
require 'active_support'

# Benchmarking for TestReports
require 'benchmark'
include Benchmark


# Now, connect to the database using ActiveRecord
ActiveRecord::Base.establish_connection(YAML.load_file(File.dirname(__FILE__) + "/../config/database.yml"))


# Now load the Model(s).
Dir[File.dirname(__FILE__) + "/../app/models/*.rb"].each do |filename|
  # "#{filename}" == filename.to_s == filename - so just call filename
  load filename
end


# Now create both a Command and a Report object
#@command = Command.new
@test_report = TestReport.new


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
        File.foreach(ARGV[0]) do |cmd|

          # Strip off the ending '\n'
          cmd.strip!
          
          # Skip any comment lines
          next if cmd =~ /^#/ or cmd.empty?
          
          # Assign the command found to the cmd variable
          @test_report.run_command cmd
          
          # Save @test_report so its ID is generated. This also saves @command and associates it wiith this @test_report
          @test_report.save
        end
      rescue Errno::ENOENT => e
        # The file wasn't found so display the help and abort.
        cmdline.help
        abort
      end
      # BATCH HAS BEEN PROCESSED
      # Now that all the commands in the batch have been processed and added to test_report,
      # now is when to save the Test Report, immediately following the processing of all commands.
      @test_report.save!
      
      # Now we artistically display a report of every command processed in the batch.
      @test_report.display_long_report
      
else
  # PROCESS SINGLE COMMAND
  # All is good so onwards and upwards! This handles when just a single command,
  # not a script, is passed. Since its not a script, ARGV[0] should be the command to be run encased in ''.
  @test_report.run_command ARGV[0]
  @test_report.display_short_report

end

# Explicitly return 0 for success if we've made it here.
exit 0
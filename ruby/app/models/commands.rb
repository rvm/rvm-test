class Command < ActiveRecord::Base
  belongs_to :test_reports, :autosave => true

  before_create do |command|
    # Capture the system's name and its OS
    command.sysname = %x[uname -n].strip
    command.os_type = %x[uname -s].strip
  end

  def env_to_hash(env_string)
    lines = env_string.split("\n")
    key_value_pairs = lines.map { |line|
      key, value = *line.split("=", 2)
      [key.to_sym, value]
    }

    Hash[key_value_pairs]
  end
  
  def run( cmd, bash )
    stdout, stderr = StringIO::new, StringIO::new
    
    # set self.cmd to the passed in param, directly, stripping any '\n. as we do.
    self.cmd = cmd
    
    # Add command information to stdout
    bash.execute "echo '=====cmd:start=\"#{self.cmd}\"='", :stdout => stdout, :stderr => stderr
    Benchmark.benchmark(CAPTION) do |x|
      # Start and track timing for each individual commands, storing as a Benchmark Tms block.
      self.timings = x.report("Timings: ") do
        # Set cmd_output on self, for later processing, to the returned cmd output.
        bash.execute "#{self.cmd}", :stdout => stdout, :stderr => stderr    
      end
      # Capture pertinent information  
      self.exit_status = bash.status
      
      # Add exit status from last command to the stdout string capture
      bash.execute "echo =====cmd:exit_status=\"#{self.exit_status}\"=", :stdout => stdout, :stderr => stderr
        # This is on-screen only, so people running the test manually can see any errors.
        if self.exit_status == 1 then
          puts "#{stderr.string}"
        end
      # Add end-of-command deliniation to stdout
      bash.execute "echo =====cmd:stop=", :stdout => stdout, :stderr => stderr
      # Now we include both stdout and stderr in cmd_output. stderr will only be populated if there *was* an error.
      self.cmd_output = stdout.string + stderr.string
      self.error_msg = stderr.string
      puts "command.run EXIT STATUS: #{self.exit_status}"
      # Now, capture and display that we captured ENV from the shell for this command.
      self.env_closing = bash.execute "/usr/bin/printenv"
      puts 'Captured closing environment - #{self.env_closing}'
      # Turn the Array of env strings into a Hash for later use - Thanks apeiros_
      self.env_closing = env_to_hash(self.env_closing[0])    
    end
    
    # Create the gist, take the returned json object from Github and use the value html_url on that object
    # to set self's gist_url variable for later processing.
    self.gist_url = @@github.gists.create_gist(:description => cmd, :public => true, :files => { "console.sh" => { :content => cmd_output.presence || "Cmd had no output" }}).html_url
  end
  
  def dump_obj_store
    File.open('db/commands_marshalled.rvm', 'w+') do |report_obj|
      Marshal.dump(self, report_obj)
    end
  end
  
  def load_obj_store
    File.open'db/commands_marshalled.rvm' do |report_obj|
      test_report.commands = Marshal.load(report_obj)      
      return test_report.commands
    end
  end
  
end

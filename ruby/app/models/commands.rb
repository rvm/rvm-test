class Command < ActiveRecord::Base
  belongs_to :test_reports

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
    Benchmark.benchmark(CAPTION) do |x|
      # Start and track timing for each individual commands, storing as a Benchmark Tms block.
      self.timings = x.report("Timings: ") do
        # Set cmd_output on self, for later processing, to the returned cmd output.
        bash.execute "#{self.cmd}", :stdout => stdout, :stderr => stderr    
        
        self.exit_status = bash.status
        self.cmd_output = stdout.string
        self.error_msg = stderr.string
        
      end  
      puts "command.run EXIT STATUS: #{self.exit_status}"
      self.env_closing = bash.execute "/usr/bin/printenv | grep -i rvm"
      puts 'Captured closing environment - #{self.env_closing}'
      self.env_closing = env_to_bash(self.env_closing)
      p self.env_closing.keys
         # String
        # Returned a array of strings like: "rvm_dump_environment_flag=0"
        # Want to split on '=' for each string entry and make left side the key, right the value
        #p Hash.new(env.split().map{|line| line.split('=')})
        # BLEH - Failing to figure how to convert.
      end
      puts "CLOSING HASH"
      p self.env_closing.values
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

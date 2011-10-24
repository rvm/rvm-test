class Command < ActiveRecord::Base
  belongs_to :test_report

  before_create do |command|
    # Capture the system's name and its OS
    command.sysname = %x[uname -n].strip
    command.os_type = %x[uname -s].strip
  end

  def run( cmd )
    # set self.cmd to the passed in param, directly, stripping any '\n. as we do.
    self.cmd = cmd.strip
    
    Benchmark.benchmark(CAPTION) do |x|
      # Start and track timing for each individual commands, storing as a Benchmark Tms block.
      self.timings = x.report("Timings: ") do
        # Set cmd_output on self, for later processing, to the returned cmd output.
        self.cmd_output = %x[ #{self.cmd} 2>&1 ]
      end
    end

    # Create the gist, take the returned json object from Github and use the value html_url on that object
    # to set self's gist_url variable for later processing.
    self.gist_url = @@github.gists.create_gist(:description => cmd, :public => true, :files => { "console.sh" => { :content => cmd_output.presence || "Cmd had no output" }}).html_url
  end
  
end

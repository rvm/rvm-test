class Command < ActiveRecord::Base
  belongs_to :test_report

  before_create do |command|
    # Capture the system's name and its OS
    command.sysname = %x[uname -n].strip
    command.os_type = %x[uname -s].strip
  end

  def run( cmd )
    self.cmd = cmd
    
    Benchmark.benchmark(CAPTION) do |x|
      self.timings = x.report("Timings: ") do
        self.cmd_output = %x[ #{self.cmd} 2>&1 ]
      end
    end
    # TODO - handle nil in self.cmd_output in usage for :content population
    # Just using the " || ' '" in the string to roughly handle nil valued self.cmd_output
    gist = @@github.gists.create_gist :description => self.cmd, :public => true, :files => { "console.sh" => { :content => self.cmd_output.blank? ? "Cmd had no output" : self.cmd_output }}
    self.gist_url = "#{gist.html_url}"
  end
  
end

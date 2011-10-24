class TestReport < ActiveRecord::Base
  has_many :commands
    
  def record_timings(&cmds)
    Benchmark.benchmark(CAPTION) do |x|
      x.report("Timings: ", &cmds)
    end
  end

  def github(login_string)
    Github.new(:login => "#{login_string[:login]}", :user => "#{login_string[:user]}", :password => "#{login_string[:password]}", :repo => "#{login_string[:repo]}")    
  end

  def run_command( cmd )
    command = commands.build
    command.run( cmd )
    command.save
    self.sysname = command.sysname
  end
  
  def display_combined_gist_report
      self.report = self.display_short_report()
      
      pretty_print "The Complete report URL is: #{@@github.gists.create_gist(:description => "Complete Report", :public => true, :files => { "console.sh" => { :content => report.presence.to_s || "Cmd had no output" }}).html_url}"
  end
  
  def display_short_report
    self.commands.each do |command|
      puts "Test Report for : " + "#{command.sysname} - " + "Cmd ID: " + command.id.to_s + " - Executed: \"#{command.cmd.to_s}\"" + " at " +  "#{command.updated_at.to_s}" + " Gist URL: #{command.gist_url}"
    end
  end
  
  def dump_obj_store
    File.open('db/marshalled.rvm', 'w+') do |report_obj|
      Marshal.dump(self, report_obj)
    end
  end
  
  def load_obj_store
    File.open'db/marshalled.rvm' do |report_obj|
      @test_report = Marshal.load(report_obj)
      
      puts "Inside load_obj_store - at p self\n"
      p self # What do *I* look like?
  
      # What does the newly loaded @test_report look like (this should be this object, referred to by its name rather than self.)
      puts "Inside load_obj_store - at p @test_report.commands.inspect\n"
      p @test_report.commands.inspect
      
    end
  end
  
  
end
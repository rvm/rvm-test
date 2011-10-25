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
      puts "The Complete report URL is: #{@@github.gists.create_gist(:description => "Complete Report", :public => true, :files => { "console.sh" => { :content => report.presence || "Cmd had no output" }}).html_url}"
  end
  
  def display_short_report
    self.commands.each do |command|
      puts "Test Report for : #{command.test_report_id}" + "on #{command.sysname} - " + "Cmd ID: " + command.id.to_s + " - Executed: \"#{command.cmd.to_s}\"" + " at " +  "#{command.updated_at.to_s}" + " Gist URL: #{command.gist_url}"
    end
  end
  
  def dump_obj_store
    File.open('db/testreport_marshalled.rvm', 'w+') do |report_obj|
      puts "\nDumping TestReport object store\n"
      Marshal.dump(self, report_obj)
    end
    puts "\nDumping Command object store\n"
    self.commands.each do |cmd|
      cmd.dump_obj_store
    end
  end
  
  def load_obj_store
    File.open'db/testreport_marshalled.rvm' do |report_obj|
      puts "\nLoading TestReport object store\n"
      @test_report = Marshal.load(report_obj)
      puts "\nHere are test_report and test_report.commands\n"
      p @test_report
      p "\n"
      p @test_report.commands
    end
    
    puts "\nStill in load_obj_store - Calling p @test_report\n"
    puts "Loaded TestReport ID is: " "#{@test_report.id}"
    puts "@test_report is of class " + "#{@test_report.class}\n"    
    p @test_report
    puts "\nCalling p @test_report.commands\n"
    p @test_report.commands
    puts "\nExiting load_obj_store - Returning @test_report"
    return @test_report
  end
  
  
end
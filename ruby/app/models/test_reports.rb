class TestReport < ActiveRecord::Base
  # has_and_belongs_to_many :commands, :join_table => "test_reports_commands"
  has_many :commands
  
  accepts_nested_attributes_for :commands, :allow_destroy => true, :reject_if => proc { |attributes| attributes['cmd'].blank? }
  
    
  def record_timings(&cmds)
    Benchmark.benchmark(CAPTION) do |x|
      x.report("Timings: ", &cmds)
    end
  end

  def github(login_string)
    Github.new(:login => "#{login_string[:login]}", :user => "#{login_string[:user]}", :password => "#{login_string[:password]}", :repo => "#{login_string[:repo]}")    
  end

  def run_command( cmd, bash )
    command = commands.build
    command.run( cmd, bash )
    command.save
    self.sysname = command.sysname
  end
  
  def display_combined_gist_report
      self.report = self.display_short_report()
      self.gist_url = "#{@@github.gists.create_gist(:description => "Complete Report", :public => true, :files => { "console.sh" => { :content => report.presence || "Cmd had no output" }}).html_url}"
      puts "The Complete report URL is: #{self.gist_url} - Report Exit Status: #{self.exit_status}" 
  end
  
  def display_short_report
    self.commands.each do |command|
      puts "Test Report for: #{command.test_report_id}" + " - Test Node: #{command.sysname} - " + "Cmd ID: " + command.id.to_s + " - Executed: \"#{command.cmd.to_s}\"" + " at " +  "#{command.updated_at.to_s}" + " Gist URL: #{command.gist_url}" + " Cmd exit code: #{command.exit_status}"
    end
  end
  
  def dump_obj_store
    File.open('db/testreport_marshalled.rvm', 'w+') do |report_obj|
      puts "\nDumping TestReport object store"
      Marshal.dump(self, report_obj)
    end
    puts "Dumping Command object store\n"
    self.commands.each do |cmd|
      cmd.dump_obj_store
    end
  end
  
  def load_and_replay_obj_store
    @bash = Session::Bash.new
    
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
    
    puts "Replaying commands "
    @test_report.commands.each do |cmd, bash|
      cmd.run cmd.cmd, @bash
    end
    
    # Recreate a gisted report of this new run based off the marshalled object(s)
    @test_report.display_combined_gist_report
    puts "\nExiting load_obj_store\n"
  end
  
  def open_session
    
  end
  
end
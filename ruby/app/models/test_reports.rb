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
  
  def display_short_report
    self.commands.each do |command|
      puts "Test Report for : " + "#{command.sysname} - " + "Cmd ID: " + command.id.to_s + " - Executed: \"#{command.cmd.to_s}\"" + " at " +  "#{command.updated_at.to_s}" + " Gist URL: #{command.gist_url}"
    end
  end
  
  def display_long_report
    # Next, we sort this particular report's commands on the ID field, then we can promise to display them in the order they were issued.
    # We only want the commands associated with this particular TestReport object, so we use self to build the command.
    self.commands.sort! { |old,cur| old.id <=> cur.id }
    
    self.commands.each do |command|
      puts "\t\t\t\t*************** [ TESTING REPORT FOR #{command.sysname} ] ***************\t\t\t\t\n\n"
      puts " REPORT ID #: #{self.id}\n COMMAND ID #: #{command.id}\n SYSTEM TYPE: #{command.os_type}\n EXECUTED COMMAND: #{command.cmd}\n Gist URL: #{command.gist_url}\n TIMINGS: "
      puts "#{command.timings} "
      puts  "\nCOMMAND OUTPUT: #{command.cmd_output}\n"
    end
  end
  
  def gist_it
    # TODO Implement api.github.com gisting 
  end
end

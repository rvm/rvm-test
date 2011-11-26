class TestReport < ActiveRecord::Base

  # Github API interface
  require 'github_api'

  attr_accessor :my_github, :login_string

  has_many :commands

  accepts_nested_attributes_for :commands, :allow_destroy => true, :reject_if => proc { |attributes| attributes['cmd'].blank? }

  def initialize

    super

    # We log into github via the TestReport github call because it should be the TestReport that spawns the connection, not Command.
    #
    # So its not in the repository, we put the auth strings, in yaml format, into config/github.yml file and load it to @login_string.
    # This gives us self.login_string (@test_report.login_string) and self.my_github (@test_report.my_github) to be used later.
    self.login_string = YAML.load_file("#{APP_ROOT}/config/github.yml")
    self.my_github = self.github(@login_string)
  end

  def record_timings(&cmds)
    Benchmark.benchmark(CAPTION) do |x|
      x.report("Timings: ", &cmds)
    end

  end

  def github(login_string)
    return Github.new(:login => "#{login_string[:login]}", :user => "#{login_string[:user]}", :password => "#{login_string[:password]}", :repo => "#{login_string[:repo]}")
  end

  def env_to_hash(env_string)
    lines = env_string.split("\n")
    key_value_pairs = lines.map { |line|
      key, value = *line.split("=", 2)
      [key.to_sym, value]
    }

    Hash[key_value_pairs]


  end

  def run_command( cmd, test_report, bash )
    command = commands.build
    command.run( cmd, test_report, bash )
    command.save
    self.sysname = command.sysname


  end

  def display_combined_gist_report
    self.report = self.display_short_report()
    self.gist_url = "#{self.my_github.gists.create_gist(:description => "Complete Report", :public => true, :files => { "console.sh" => { :content => report.presence || "Cmd had no output" }}).html_url}"
    puts "The Complete report URL is: #{self.gist_url} - Report Exit Status: #{self.exit_status}"


  end

  def display_short_report
    self.commands.each do |command|
      puts "Test Report for: #{command.test_report_id}" + " - Test Node: #{command.sysname} - " + "Cmd ID: " + command.id.to_s + " - Executed: \"#{command.cmd.to_s}\"" + " at " +  "#{command.updated_at.to_s}" + " Gist URL: #{command.gist_url}" + " Cmd exit code: #{command.exit_status}"
    end
  end

end

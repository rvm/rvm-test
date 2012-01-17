class Command < ActiveRecord::Base
  belongs_to :test_reports, :autosave => true
  attr_accessor :env_starting

  RED = `tput setaf 1`
  GREEN = `tput setaf 2`
  YELLOW = `tput setaf 3`
  BLUE = `tput setaf 4`
  RESET = `tput sgr0`

  def short _short
    @short = _short
  end

  before_create do |command|
    # Capture the system's name and its OS
    command.sysname = %x[uname -n].strip
    command.os_type = %x[uname -s].strip
  end

  def env_to_hash(env_string)
    # Convert the captured environment to a Hash where the env var_names are the keys
    lines = env_string.split("\n")
    key_value_pairs = lines.map { |line|
      key, value = *line.split("=", 2)
      [key.to_sym, value]
    }

    Hash[key_value_pairs]
  end

  def test_output_status sign, value
    # Convert value to integer for the coming test
    value = value.to_i
    
    # This test means True or false, if sign's value is "="  OR  if self.exit_status equals the integer value of 'value'
    # if one of those two tests are True, then set self.test_failed to 1, and report accordingly - Also known as an eXclusive OR (XOR)
    # This is what is meant by the ^ in the next line.
    if ( sign == "=" ) ^ ( self.exit_status == value )
      self.test_failed+=1
      "failed: status #{sign} #{value} # was #{self.exit_status}"
    else
      "passed: status #{sign} #{value}"
    end
  end

  def test_output_match sign, value
    # See comment in test_output_status. First part is the same in both tests. Here we test if self.cmd_output contains 'value'
    # If the contents of 'value' are in self.cmd_output, its of course True, and Regexp.new's job is to return value's
    # starting location (starting from 0 as a position, starting at the beginning of the string). This is called an eXclusive OR. 
    # This is a logical test on two operands that results in a value of true if exactly one of the operands has a value of true.
    # A simple way to state this is "one or the other but not both.". This is referring to the '^' in the following line of code.
    if ( sign == "=" ) ^ ( Regexp.new(value) =~ "#{self.cmd_output}" )
      self.test_failed+=1
      "failed: match #{sign} /#{value}/"
    else
      "passed: match #{sign} /#{value}/"
    end
  end

  def test_env_match variable, sign, value
    var_val = self.env_closing[ variable.to_sym ]
    if ( sign == "=" ) ^ ( Regexp.new(value) =~ "#{var_val}" )
      self.test_failed+=1
      "failed: env #{variable} #{sign} /#{value}/ # was '#{var_val}'"
    else
      "passed: env #{variable} #{sign} /#{value}/"
    end
  end

  def test_command
    # reset test status
    self.test_failed = 0
    self.test_output = nil
    # do nothing when no tests
    return if self.test_text.nil?

    # read the tests
    tests = self.test_text.split(/;/).map(&:strip)
    outputs = []
    tests.each do |test|
      # check for status=... or status!=...
      if test =~ /^status([!]?=)(.*)/
        # pass in the operator($1) and tested value($2)
        outputs.push( test_output_status( $1, $2 ) )

      # check for match=~... or match!=~...
      elsif test =~ /^match([!]?=)[~]?\/(.*)\//
        # pass in the operator($1) and tested value($2)
        outputs.push( test_output_match( $1, $2 ) )

      # check for env[...]=~... or env[...]!=~...
      elsif test =~ /^env\[(.*)\]([!]?=)[~]?\/(.*)\//
        # pass in the variable($1) operator($2) and tested value($3)
        outputs.push( test_env_match( $1, $2, $3 ) )

      else
        outputs.push("invalid test: #{test}")
      end
    end

    # join array items with new lines and append new line on the end
    self.test_output = outputs * "\n" + "\n"

    if @short
      $stderr.puts outputs.map{|s| s =~ /^failed: / ? "#{RED}# #{s}#{RESET}" : "#{GREEN}# #{s}#{RESET}" } * "\n" + "\n"
    else
      $stderr.puts self.test_output
    end
  end

  def run( cmd, bash )
    # clean cmd
    cmd.strip!

    # detect if command is followed by test in comment: command # test
    if cmd =~ /^(.*)\#(.*)$/
      self.cmd = $1.strip
      self.test_text = $2.strip
    else
      self.cmd = cmd
    end

    # Ensure that self.error_msg and self.cmd_output are blank
    # Do this before we get anywhere near the timing and command execution blocks
    self.error_msg = self.cmd_output = ""

    # Source rvm so we can use rvm as function
    bash.execute 'source ${rvm_scripts_path:-$rvm_path/scripts}/rvm'

    # Record starting env so we can check it in tests
    self.env_starting = bash.execute "/usr/bin/printenv"
    self.env_starting = env_to_hash(self.env_starting[0])

    if @short
      if /^: / =~ self.cmd
        puts ""
        puts "#{BLUE}#{self.cmd.gsub(/^: /, "### ")}#{RESET}"
      else
        puts "#{YELLOW}$ #{self.cmd}#{RESET}"
      end
      bash.execute "#{self.cmd}" do |out, err|
        # properly map errors and output in the order they show up
        self.cmd_output += err if err
        self.cmd_output += out if out
        puts out || err
        # self.error_msg is only be populated on errors. stored for later retrieval without
        # having to also read through non-error output.
        self.error_msg += err if err
      end
      self.exit_status = bash.status

    else
      Benchmark.benchmark(CAPTION) do |x|
        # Start and track timing for each individual commands, storing as a Benchmark Tms block.
        self.timings = x.report("Timings: ") do
          # Set cmd_output on self, for later processing, to the returned cmd output.
          bash.execute "#{self.cmd}" do |out, err|
            # properly map errors and output in the order they show up
            self.cmd_output += err if err
            self.cmd_output +=  out if out
            # self.error_msg is only be populated on errors. stored for later retrieval without
            # having to also read through non-error output.
            self.error_msg += err if err
          end
        end
        # Capture pertinent information
        self.exit_status = bash.status
      end

      # This is on-screen only, so people running the test manually can see any errors.
      if self.exit_status == 1 then
        puts "#{stderr.string}"
      end

      # Let screenies know the exit status
      puts "COMMAND EXIT STATUS: #{self.exit_status}"
    end

    # Now, capture ENV from the shell for this command in the current command object itself.
    self.env_closing = bash.execute "/usr/bin/printenv"
    # Turn the Array of env strings into a Hash for later use - Thanks apeiros_
    self.env_closing = env_to_hash(self.env_closing[0])

    test_command
    
    if ! @short
      # Create the gist, take the returned json object from Github and use the value html_url on that object
      # to set self's gist_url variable for later processing.
      self.gist_url = @@github.gists.create_gist(:description => cmd, :public => true, :files => { "console.sh" => { :content => gist_content }}).html_url
    end
  end

  def gist_content
    content = cmd_output.presence || "Cmd had no output"
    if test_output
      content += "Tests(failed #{test_failed}):\n" + test_output
    else
      content += "No tests defined\n"
    end
    content
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

require 'minitest/autorun'

class TestCommandShort < MiniTest::Unit::TestCase
  def setup
    @command = Command.new
    @command.short true
    @command.silent true
    @bash = Session::Bash.new
  end

  def test_status_success
    @command.run "true # status=0", @bash
    assert_equal @command.test_failed, 0
    assert_equal @command.test_output, "passed: status = 0\n"
  end
  def test_status_failed
    @command.run "false # status=0", @bash
    assert_equal @command.test_failed, 1
    assert_equal @command.test_output, "failed: status = 0 # was 1\n"
  end
  def test_status_not_success
    @command.run "false # status!=0", @bash
    assert_equal @command.test_failed, 0
    assert_equal @command.test_output, "passed: status != 0\n"
  end
  def test_status_not_failed
    @command.run "true # status!=0", @bash
    assert_equal @command.test_output, "failed: status != 0 # was 0\n"
  end

  def test_match_success
    @command.run "echo \"test\" # match=/test/", @bash
    assert_equal @command.test_failed, 0
    assert_equal @command.test_output, "passed: match = /test/\n"
  end
  def test_match_failed
    @command.run "echo \"other\" # match=/test/", @bash
    assert_equal @command.test_output, "failed: match = /test/\n"
  end  
  def test_match_not_success
    @command.run "echo \"other\" # match!=/test/", @bash
    assert_equal @command.test_failed, 0
    assert_equal @command.test_output, "passed: match != /test/\n"
  end
  def test_match_not_failed
    @command.run "echo \"test\" # match!=/test/", @bash
    assert_equal @command.test_output, "failed: match != /test/\n"
  end

  def test_env_success
    @command.run "export TESTVAR=test # env[TESTVAR]=/test/", @bash
    assert_equal @command.test_failed, 0
    assert_equal @command.test_output, "passed: env TESTVAR = /test/\n"
  end
  def test_env_failed
    @command.run "export TESTVAR=other # env[TESTVAR]=/test/", @bash
    assert_equal @command.test_output, "failed: env TESTVAR = /test/ # was 'other'\n"
  end  
  def test_env_not_success
    @command.run "export TESTVAR=other # env[TESTVAR]!=/test/", @bash
    assert_equal @command.test_failed, 0
    assert_equal @command.test_output, "passed: env TESTVAR != /test/\n"
  end
  def test_env_not_failed
    @command.run "export TESTVAR=test # env[TESTVAR]!=/test/", @bash
    assert_equal @command.test_output, "failed: env TESTVAR != /test/ # was 'test'\n"
  end

  def test_multiple_tests_passed
    @command.run "export TESTVAR=test ; echo test ; false # status!=0; match=/test/; env[TESTVAR]=/test/", @bash
    outputs = @command.test_output.split("\n").reject{ |o| o.nil? }
    assert_equal outputs.length, 3
    assert_equal @command.test_failed, 0
    assert_includes outputs, "passed: status != 0"
    assert_includes outputs, "passed: match = /test/"
    assert_includes outputs, "passed: env TESTVAR = /test/"
  end
  def test_multiple_tests_failed
    @command.run "export TESTVAR=other ; echo other ; true # status!=0; match=/test/; env[TESTVAR]=/test/", @bash
    outputs = @command.test_output.split("\n").reject{ |o| o.nil? }
    assert_equal outputs.length, 3
    assert_equal @command.test_failed, 3
    assert_includes outputs, "failed: status != 0 # was 0"
    assert_includes outputs, "failed: match = /test/"
    assert_includes outputs, "failed: env TESTVAR = /test/ # was 'other'"
  end
end

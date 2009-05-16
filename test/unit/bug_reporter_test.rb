require 'test_helper'

class BugReporterTest < ActionMailer::TestCase
  test "report_bug" do
    @expected.subject = 'BugReporter#report_bug'
    @expected.body    = read_fixture('report_bug')
    @expected.date    = Time.now

    assert_equal @expected.encoded, BugReporter.create_report_bug(@expected.date).encoded
  end

end

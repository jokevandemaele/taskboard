require 'test_helper'

class BugReporterTest < ActionMailer::TestCase
  context "#bug_report" do
    setup do
      @user = Factory(:user)
      @response = BugReporter.deliver_bug_report("bug", "message", @user)
    end
    should "send the email" do
      assert !ActionMailer::Base.deliveries.empty? 
    end
    should "have the correct subject" do
      assert_equal "[TASKBOARD-BUG-REPORT] From: #{@user.name} <#{@user.email}> - bug", @response.subject
    end
    should "have the correct sender" do
      assert_equal ["taskboard@agilar.org"], @response.from
    end
    should "have the correct recipients" do
      assert_equal ['agilar-dev-team@googlegroups.com'], @response.to
    end
    should "have the correct body" do
      assert_match /message/, @response.body
    end
  end
end

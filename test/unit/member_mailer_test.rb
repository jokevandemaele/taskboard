require 'test_helper'

class MemberMailerTest < ActionMailer::TestCase
  test "invite" do
    # @expected.subject = 'MemberMailer#invite'
    # @expected.body    = read_fixture('invite')
    # @expected.date    = Time.now

    # assert_equal @expected.encoded, MemberMailer.create_invite(@expected.date).encoded
  end

  test "create" do
    @member = Member.new(:name => 'marquete', :username => 'marquete', :password => 'secret', :email => 'marquete@gmail.com')
    @member.save
    @member.add_to_organization(organizations(:widmore_corporation).id)
    @response = MemberMailer.deliver_create(@member, 'secret', 'Charles Widmore', 'http://www.example.com/')
    assert_equal 'Welcome to the Agilar Taskboard!', @response.subject
    assert_equal 'marquete@gmail.com', @response.to[0]
    assert_match /marquete/, @response.body
    assert !ActionMailer::Base.deliveries.empty? 
  end

end

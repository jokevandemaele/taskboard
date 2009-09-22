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
    @member.new_organization = organizations(:widmore_corporation).id
    @member.save
    @response = MemberMailer.deliver_create(@member)
    assert_equal 'Welcome to the Agilar Taskboard!', @response.subject
    assert_equal ['marquete@gmail.com'], @response.to
    assert_match /marquete/, @response.body
    assert_match /secret/, @response.body
    assert !ActionMailer::Base.deliveries.empty? 
  end

  test "add_guest_to_projects" do
    @response = MemberMailer.deliver_add_guest_to_projects(members(:dfaraday), 'Charles Widmore', [projects(:escape_from_the_island).id, projects(:come_back_to_the_island).id])
    assert_equal 'You have been added as a guest member', @response.subject
    assert_equal members(:dfaraday).email, @response.to[0]
    assert_match 'Charles Widmore', @response.body
    assert_match projects(:escape_from_the_island).name, @response.body
    assert_match projects(:come_back_to_the_island).name, @response.body
    assert !ActionMailer::Base.deliveries.empty? 
  end
end

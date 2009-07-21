require 'test_helper'

class MemberMailerTest < ActionMailer::TestCase
  test "invite" do
    @expected.subject = 'MemberMailer#invite'
    @expected.body    = read_fixture('invite')
    @expected.date    = Time.now

    assert_equal @expected.encoded, MemberMailer.create_invite(@expected.date).encoded
  end

  test "create" do
    @expected.subject = 'MemberMailer#create'
    @expected.body    = read_fixture('create')
    @expected.date    = Time.now

    assert_equal @expected.encoded, MemberMailer.create_create(@expected.date).encoded
  end

end

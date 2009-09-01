require 'test_helper'

class StoryTest < ActiveSupport::TestCase
	test "every story should be created with a template task" do
		s = Story.create(:realid => "AAA111")
		assert_equal 1, s.tasks.size
	end

	test "the default story priority is 0" do
		s = Story.create(:realid => "AAA1112")
		assert_equal 0, s.priority
	end
  
  test "start, stop and finish work ok" do
    story = Story.create(:realid => "AAAA113")
    assert story.stopped?
    story.start
    assert story.started?
    story.stop
    assert story.stopped?
    story.finish
    assert story.finished?
    assert_equal -1, story.priority
  end

end

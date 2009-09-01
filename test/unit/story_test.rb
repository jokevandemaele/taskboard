require 'test_helper'

class StoryTest < ActiveSupport::TestCase
	test "every story should be created with a template task" do
		s = Story.create(:realid => "AAA111")
		assert_equal 1, s.tasks.size
	end

	test "the default story priority is 10 less than the lower one, or zero if that is zero" do
		s = Story.create(:project => projects(:come_back_to_the_island), :realid => "AAB1112", :priority => 100)
		assert_equal 100, s.priority
		s = Story.new
		assert_equal 90, s.next_priority(projects(:come_back_to_the_island).id)
		s = Story.create(:project => projects(:come_back_to_the_island), :realid => "AAB1122")
		assert_equal 90, s.priority
		s = Story.create(:project => projects(:come_back_to_the_island), :realid => "AAB1132", :priority => 28)
		assert_equal 28, s.priority
		s = Story.create(:project => projects(:come_back_to_the_island), :realid => "AAB1142")
		assert_equal 18, s.priority
		s = Story.create(:project => projects(:come_back_to_the_island), :realid => "AAB1152", :priority => 0)
		assert_equal 0, s.priority
		s = Story.new
		assert_equal 0, s.next_priority(projects(:come_back_to_the_island).id)
		s = Story.create(:project => projects(:come_back_to_the_island), :realid => "AAB1162", :priority => 0)
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

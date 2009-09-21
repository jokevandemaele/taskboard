require 'test_helper'

class StoryTest < ActiveSupport::TestCase
  test "every story should belong to a project" do
    story = Story.new
    assert !story.save
    story = Story.new(:project => projects(:come_back_to_the_island))
    assert story
  end

	test "every story should be created with a template task" do
		s = Story.create(:project => projects(:come_back_to_the_island))
		assert_equal 1, s.tasks.size
	end
  
  test "Story next_readlid is selected correctly and stories assing it automatically" do
    assert_equal "EF002", Story.next_realid(projects(:escape_from_the_island))
    s = Story.create(:project => projects(:escape_from_the_island), :priority => 100)
    assert_equal "EF002", s.realid
    assert_equal "EF003", Story.next_realid(projects(:escape_from_the_island))
    s = Story.new(:project => projects(:escape_from_the_island), :priority => 100)
    assert_equal "EF003", s.realid
    s.save
    assert_equal "EF003", s.realid
    assert_equal "EF004", Story.next_realid(projects(:escape_from_the_island))

    # s = Story.create(:project => projects(:escape_from_the_island), :realid => 'EF999')
    # s.save
    # assert_equal 'EF999', s.realid
    # s = Story.create(:project => projects(:escape_from_the_island))
    # assert_equal 'EF1000', s.realid
    # s.save
    # assert_equal 'EF1001', Story.next_realid(projects(:escape_from_the_island))
  end
  
	test "the default story priority is 10 less than the lower one, or zero if that is zero" do
		s = Story.create(:project => projects(:come_back_to_the_island), :realid => "AAB1112", :priority => 100)
		assert_equal 100, s.priority
		s = Story.create(:project => projects(:come_back_to_the_island), :realid => "AAB1122")
		assert_equal 90, s.priority
		s = Story.create(:project => projects(:come_back_to_the_island), :realid => "AAB1132", :priority => 28)
		assert_equal 28, s.priority
		s = Story.create(:project => projects(:come_back_to_the_island), :realid => "AAB1142")
		assert_equal 18, s.priority
		s = Story.create(:project => projects(:come_back_to_the_island), :realid => "AAB1152", :priority => 5)
		assert_equal 5, s.priority
		s = Story.create(:project => projects(:come_back_to_the_island), :realid => "AAB1162", :priority => -5)
		assert_equal 0, s.priority
		s = Story.create(:project => projects(:come_back_to_the_island), :realid => "AAB1172", :priority => 0)
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

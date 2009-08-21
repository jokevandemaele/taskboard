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

end

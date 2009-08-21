require 'test_helper'

class StoryTest < ActiveSupport::TestCase
	test "every story should be created with a template task" do
		s = Story.create(:realid => "AAA111")
		assert_equal 1, s.tasks.size
	end
end

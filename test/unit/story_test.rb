require 'test_helper'

class StoryTest < ActiveSupport::TestCase
	test "every story should be created with a template task" do
		s = Story.new
		s.save
		assert_equal 1, s.tasks.size
	end
end

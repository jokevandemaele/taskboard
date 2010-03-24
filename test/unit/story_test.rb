require File.dirname(__FILE__) + '/../test_helper'

class StoryTest < ActiveSupport::TestCase
  context "Story" do
    setup do
      @project = Factory(:project)
    end
    
    ################################################################################################################
    #
    # Associations
    #
    ################################################################################################################
    should_belong_to :project
    should_have_many :tasks
    
    ################################################################################################################
    #
    # Validations
    #
    ################################################################################################################
    should_validate_presence_of :project
    should_validate_presence_of :realid
    should_validate_presence_of :name
    should_validate_presence_of :priority
    should_allow_values_for :priority, 0, 10, 20
    should_not_allow_values_for :priority, "hola", "okaopsdgjko", "1 bla", "20 asdasd"
    
  end
  
  context "When created" do
    setup do
      @project = Factory(:project)
    end

    should "have a template task" do
      assert_equal 1, @project.stories.first.tasks.size
    end
    
  end
  
  context "The default story priority" do
    setup do
      @project = Factory(:project)
      @project.stories.create(:name => "A story", :priority => 100)
      @story = @project.stories.create(:name => "A story 2")
    end
    
    should "be 10 less thatn the lower one" do
      assert_equal 90, @story.priority
    end
    
    context "if the last priority is > 10" do
      setup do
        @project.stories.create(:name => "A story", :priority => 28)
        @story = @project.stories.create(:name => "A story")
      end

      should "be 10 less than the lower one" do
        assert_equal 18, @story.priority
      end
    end

    context "if the last priority is = 10" do
      setup do
        @project.stories.create(:name => "A story", :priority => 10)
        @story = @project.stories.create(:name => "A story")
      end

      should "be 0" do
        assert_equal 0, @story.priority
      end
    end
    
    context "if the last priority is < 10" do
      setup do
        @project.stories.create(:name => "A story", :priority => 5)
        @story = @project.stories.create(:name => "A story")
      end

      should "be 0" do
        assert_equal 0, @story.priority
      end
    end
    
    context "if the last priority is < 0" do
      setup do
        @project.stories.create(:name => "A story", :priority => -5)
        @story = @project.stories.create(:name => "A story")
      end

      should "be 0" do
        assert_equal 0, @story.priority
      end
    end
    
    context "if the task is finished" do
      setup do
        @story = @project.stories.create(:name => "A story", :priority => 10)
        @story.finish
      end

      should "return -1" do
        assert_equal -1, @story.priority
      end
    end
  end
  
    
  ################################################################################################################
  #
  # Named Scopes
  #
  ################################################################################################################
  context "#finished named_scope" do
    setup do
      @project = Factory(:project)
    end
    
    should "return the not started stories" do
      assert_equal [], @project.stories.finished
    end
    
    context "when finished a story" do
      setup do
        @story = @project.stories.first
        @story.finish
        @project.reload
      end

      should "should return that story" do
        assert_equal [@story], @project.stories.finished
      end
    end

  end
  
  context "#in_progress named_scope" do
    setup do
      @project = Factory(:project)
    end
    
    should "return the stories in progress" do
      assert_equal [@project.stories.first], @project.stories.in_progress
    end
  end

  context "#not_started named_scope" do
    setup do
      @project = Factory(:project)
    end
    
    should "return the not started stories" do
      assert_equal [@project.stories.second], @project.stories.not_started
    end
  end
  

  context "#stories default scope" do
    setup do
      @project = Factory(:project)
      @story1 = @project.stories.first
      @story2 = @project.stories.second
      @story1.priority = 10
      @story1.stop
      @project.reload
    end

    should "return the stories in order according to the priority" do
      assert_equal [ @story2, @story1 ], @project.stories
    end
  end
  
  ################################################################################################################
  #
  # Instance Methods
  #
  ################################################################################################################
  context "Having a project" do
    setup do
      @project = Factory(:project)
    end

    context "#start" do
      setup do
        @story = @project.stories.create(:name => "A story")
        @story.start
      end

      should "should start the story" do
        assert @project.stories.in_progress.include?(@story)
        assert !@project.stories.not_started.include?(@story)
        assert !@project.stories.finished.include?(@story)
      end
    end

    context "#stop" do
      setup do
        @story = @project.stories.in_progress.first
        @story.stop
      end

      should "should stop the story" do
        assert !@project.stories.in_progress.include?(@story)
        assert @project.stories.not_started.include?(@story)
        assert !@project.stories.finished.include?(@story)
      end
    end

    context "#finish" do
      setup do
        @story = @project.stories.in_progress.first
        @story.finish
      end

      should "should finish the story" do
        assert !@project.stories.in_progress.include?(@story)
        assert !@project.stories.not_started.include?(@story)
        assert @project.stories.finished.include?(@story)
        assert_equal -1, @story.priority
      end
    end

    context "#started?" do
      setup do
        @story = @project.stories.in_progress.first
      end

      should "should return true" do
        assert @story.started?
      end
    end

    context "#stopped?" do
      setup do
        @story = @project.stories.in_progress.first
        assert @story.started?
        @story.stop
      end

      should "should return true" do
        assert @story.stopped?
      end
    end

    context "#finished?" do
      setup do
        @story = @project.stories.in_progress.first
        @story.finish
      end

      should "should return true" do
        assert @story.finished?
      end
    end
  end
  
end

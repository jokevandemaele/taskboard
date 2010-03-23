require File.dirname(__FILE__) + '/../test_helper'

class TaskTest < ActiveSupport::TestCase
  context "Task" do
    setup do
      Factory(:task)
    end
    ################################################################################################################
    #
    # Validations
    #
    ################################################################################################################
    should_validate_presence_of :story
  
    ################################################################################################################
    #
    # Associations
    #
    ################################################################################################################
    should_belong_to :story
    should_have_many :nametags
    should_have_many :statustags
  end
  
  ################################################################################################################
  #
  # Named Scopes
  #
  ################################################################################################################
  context "#finished named_scope" do
    setup do
      @story = Factory(:story)
    end
    
    should "return the finished stories" do
      assert_equal [], @story.tasks.finished
    end
    
    context "when finished a story" do
      setup do
        @task = @story.tasks.first
        @task.finish
        @story.reload
      end

      should "should return that story" do
        assert_equal [@task], @story.tasks.finished
      end
    end

  end
  
  context "#in_progress named_scope" do
    setup do
      @story = Factory(:story)
      @story.tasks.first.start
    end
    
    should "return the stories in progress" do
      assert_equal [@story.tasks.first], @story.tasks.in_progress
    end
  end

  context "#not_started named_scope" do
    setup do
      @story = Factory(:story)
    end
    
    should "return the not started stories" do
      assert_equal [@story.tasks.first], @story.tasks.not_started
    end
  end
  ################################################################################################################
  #
  # Instance Methods
  #
  ################################################################################################################
  context "#remove_tags" do
    setup do
      @user = Factory(:user)
      @task = Factory(:task)
      @task.nametags.create(:user => @user)
      assert !@task.nametags.empty?
      @task.statustags.create()
      assert !@task.statustags.empty?
      @task.remove_tags
    end

    should "remove all the existent tags" do
      assert @task.nametags.empty?
      assert @task.statustags.empty?
    end
  end
  
  context "#start" do
    setup do
      @story = Factory(:story)
      @task = @story.tasks.create()
      @task.start
    end

    should "should start the story" do
      assert @story.tasks.in_progress.include?(@task)
      assert !@story.tasks.not_started.include?(@task)
      assert !@story.tasks.finished.include?(@task)
    end
  end

  context "#stop" do
    setup do
      @story = Factory(:story)
      @task = @story.tasks.create()
      @task.start
      assert @story.tasks.in_progress.include?(@task)
      @task.stop
    end

    should "should stop the story" do
      assert !@story.tasks.in_progress.include?(@task)
      assert @story.tasks.not_started.include?(@task)
      assert !@story.tasks.finished.include?(@task)
    end
  end

  context "#finish" do
    setup do
      @story = Factory(:story)
      @task = @story.tasks.create()
      @task.start
      assert @story.tasks.in_progress.include?(@task)
      @task.finish
    end

    should "should finish the task and remove its nametags" do
      assert !@story.tasks.in_progress.include?(@task)
      assert !@story.tasks.not_started.include?(@task)
      assert @story.tasks.finished.include?(@task)
    end
  end
end

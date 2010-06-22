require File.dirname(__FILE__) + '/../test_helper'

class TaskTest < ActiveSupport::TestCase
  context "Task" do
    setup do
      @task = Factory(:task)
    end
    subject { @task }
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
    
    should "have orange as default color" do
      assert_equal 'orange', @task.color
    end
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

  context "#stopped?" do
    setup do
      @story = Factory(:story)
      @task = @story.tasks.create()
    end
    context "when the task is stopped" do
      setup do
        @task.stop
      end

      should "return true" do
        assert @task.stopped?
      end
    end
    context "when the task is not stopped" do
      setup do
        @task.start
      end

      should "return false" do
        assert !@task.stopped?
      end
    end
  end

  context "#started?" do
    setup do
      @story = Factory(:story)
      @task = @story.tasks.create()
    end
    context "when the task is started" do
      setup do
        @task.start
      end

      should "return true" do
        assert @task.started?
      end
    end
    context "when the task is not started" do
      setup do
        @task.stop
      end

      should "return false" do
        assert !@task.started?
      end
    end
  end
  
  context "#finished?" do
    setup do
      @story = Factory(:story)
      @task = @story.tasks.create()
    end
    context "when the task is finished" do
      setup do
        @task.finish
      end

      should "return true" do
        assert @task.finished?
      end
    end
    context "when the task is not finished" do
      setup do
        @task.start
      end

      should "return false" do
        assert !@task.finished?
      end
    end
  end
  
  context "#color" do
    setup do
      @task = Factory(:task)
      @task.color = 'red'
      @task.save
      @task.reload
    end

    should "should return the saved color" do
      assert_equal 'red', @task.color
    end
  end
  
end

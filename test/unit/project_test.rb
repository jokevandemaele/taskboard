require File.dirname(__FILE__) + '/../test_helper'

class ProjectTest < ActiveSupport::TestCase
  context "ProjectTest" do
    setup do
      Factory(:project)
    end
    ################################################################################################################
    #
    # Validations
    #
    ################################################################################################################
    should_validate_presence_of :organization, :name
    should_validate_uniqueness_of :name
    ################################################################################################################
    #
    # Associations
    #
    ################################################################################################################
    should_belong_to :organization
    should_have_and_belong_to_many :teams
    should_have_many :stories
    should_have_many :guest_team_memberships
    should_have_many :guest_members

    context "#guest_members" do
      setup do
        @project = Factory(:project)
        @user = Factory(:user)
        @project.guest_team_memberships.create(:user => @user, :team => @team)
        @project.save
        @project.reload
      end

      should "should return the users that have a guest membership" do
        assert_equal [ @user ], @project.guest_members
      end
    end
    
  end
  
  ################################################################################################################
  #
  # Callbacks
  #
  ################################################################################################################
  context "When created" do
    setup do
      @project = Factory(:project)
    end
    
    should "have two stories" do
      assert_equal 2, @project.stories.size
    end
    
    should "have one default in progress story" do
      assert_equal 1, @project.stories.in_progress.size
    end
    context "the sampled started story" do
      setup do
        @story = @project.stories.in_progress.first
      end
      should "have the correct name" do
        assert_equal "Sample Started Story", @story.name
      end
      should "have the correct priority" do
        assert_equal 2000, @story.priority
      end
      should "have the correct size" do
        assert_equal 10, @story.size
      end
      should "have the correct description" do
        assert_equal "This is a sample story that is started, edit it to begin using this project", @story.description
      end
    end

    should "have one the default not started story" do
      assert_equal 1, @project.stories.not_started.size
    end
    context "the sampled not started story" do
      setup do
        @story = @project.stories.not_started.first
      end
      should "have the correct name" do
        assert_equal "Sample Not Started Story", @story.name
      end
      should "have the correct priority" do
        assert_equal 1990, @story.priority
      end
      should "have the correct size" do
        assert_equal 10, @story.size
      end
      should "have the correct description" do
        assert_equal "This is a sample story that is not started, edit it to begin using this project", @story.description
      end
    end
    
    context "with public selected" do
      setup do
        @project = Factory.build(:project)
        @project.public = true
        @project.save
      end

      should "create a public hash" do
        assert_not_nil @project.public_hash 
      end
    end
    
    context "with an existing team assigned" do
      setup do
        @project = Factory.build(:project)
        @team = Factory(:team)
        @project.organization = @team.organization
        @project.team = @team.id
        @project.save
      end
      
      should "assing the user to that team" do
        assert @project.teams.include?(@team)
      end
    end
    
  end # End when created
  

  ################################################################################################################
  #
  # Instance Methods
  #
  ################################################################################################################
  context "#team_including" do
    setup do
      @project = Factory(:project)
      @user = Factory(:user)
      @other_user = Factory(:user)
      @team1 = Factory(:team)
      @project.teams << @team1
      @team2 = Factory(:team)
      @project.teams << @team2
      @project.save
      @team2.users << @user
      @team2.save
    end

    should "return the team that includes the given user" do
      assert_equal @team2, @project.team_including(@user)
    end
    
    should "return the first team" do
      assert_equal @project.teams.first, @project.team_including(@other_user)
    end
  end
  
  context "#users" do
    setup do
      @project = Factory(:project)
      @user = Factory(:user)
      @team = Factory(:team)
      
      @team.users << @user
      @team.save
      @team.reload
      
      @project.teams << @team
      @project.save
      @project.reload
    end

    should "return the users that belong to the project" do
      assert_equal [ @user ], @project.users
    end
    context "when having guest members" do
      setup do
        @user1 = Factory(:user)
        @team1 = Factory(:team)
        @project.guest_team_memberships.create(:user => @user1, :team => @team1)
        @project.save
        @project.reload
      end

      should "include them too" do
        assert_equal [ @user, @user1 ], @project.users
      end
    end
    
  end
  
  context "#next_priority" do
    setup do
      @project = Factory(:project)
    end

    should "return 10 less than the last story" do
      assert_equal 1980, @project.next_priority
    end

    context "with a story with priority = 100" do
      setup do
        @story = @project.stories.create(:name => "A new story", :priority => 100)
      end

      should "return 90" do
        assert_equal 90, @project.next_priority
      end
    end
    
    context "with a story with priority < 10" do
      setup do
        @project.stories.create(:name => "A new story", :priority => 5)
      end

      should "the priority should be 0" do
        assert_equal 0, @project.next_priority
      end
    end

    context "with a story with priority < 0" do
      setup do
        @project.stories.create(:name => "A new story", :priority => -10)
      end

      should "the priority should be 0" do
        assert_equal 0, @project.next_priority
      end
    end
    
    context "if the project has no stories" do
      setup do
        @project.stories.delete_all
        @project.save
      end

      should "should return 2000" do
        assert_equal 2000, @project.next_priority
      end
    end
  end
  
  context "#next_realid" do
    context "If it's a recently created project" do
      setup do
        @project = Factory(:project)
      end

      should "return the third" do
        assert_equal "#{@project.initials}003", @project.next_realid
      end
      
      context "and we add a story" do
        setup do
          @story = @project.stories.create(:name => "A story")
        end

        should "return the fourth" do
          assert_equal "#{@project.initials}004", @project.next_realid
        end
      end
      
      context "and add a story with realid 999" do
        setup do
          @story = @project.stories.create(:name => "A story", :realid => "#{@project.initials}999" )
        end

        should "return the 1000th" do
          assert_equal "#{@project.initials}1000", @project.next_realid
        end
      end
    end
  end
  
  context "#initials" do
    context "with a project called Agilar Taskboard" do
      setup do
        @project = Factory.build(:project)
        @project.name = "Agilar Taskboard"
        @project.save
      end

      should "return AT" do
        assert_equal "AT", @project.initials
      end
    end
    context "with a project called Project" do
      setup do
        @project = Factory.build(:project)
        @project.name = "Project"
        @project.save
      end

      should "return PR" do
        assert_equal "PR", @project.initials
      end
    end
    context "with a project called P" do
      setup do
        @project = Factory.build(:project)
        @project.name = "P"
        @project.save
      end

      should "return PP" do
        assert_equal "PP", @project.initials
      end
    end
  end
  
  context "#tasks_count" do
    setup do
      @project = Factory(:project)
    end
    should "return a hash with the count of the tasks" do
      result = { :not_started => 1, :in_progress => 0, :finished => 0}
      assert_equal result, @project.tasks_count
    end
    context "when having one started" do
      setup do
        @project.stories.first.tasks.first.start
      end

      should "return a hash with the count of the tasks" do
        result = { :not_started => 0, :in_progress => 1, :finished => 0}
        assert_equal result, @project.tasks_count
      end
    end
    
    context "when having one finished" do
      setup do
        @project.stories.first.tasks.first.finish
      end

      should "return a hash with the count of the tasks" do
        result = { :not_started => 0, :in_progress => 0, :finished => 1}
        assert_equal result, @project.tasks_count
      end
    end
  end

  context "#statustags_count" do
    setup do
      @project = Factory(:project)
    end
    should "return a hash with the count of the tasks" do
      result = {
        :high_priority => 0,
        :please_test => 0,
        :bug => 0,
        :blocked => 0,
        :done => 0,
        :waiting => 0,
        :please_analyze => 0,
        :delegated => 0,
      }
      assert_equal result, @project.statustags_count
    end
    
    ["high_priority","please_test","bug", "blocked", "done", "waiting","please_analyze", "delegated"].each do |status|
      context "with one statustag in #{status}" do
        setup do
          @task = @project.stories.first.tasks.first
          @task.statustags.create(:status => status)
          @task.save
        end
        should "return a hash with the count of the tasks" do
          result = {
            :high_priority => 0,
            :please_test => 0,
            :bug => 0,
            :blocked => 0,
            :done => 0,
            :waiting => 0,
            :please_analyze => 0,
            :delegated => 0,
          }
          result[status.to_sym] += 1
          assert_equal result, @project.statustags_count
        end
      end
    end
  end

  context "#nametags_count" do
    setup do
      @organization = Factory(:organization)
      @user = Factory(:user)
      @user.add_to_organization(@organization)
      @project = @organization.projects.first
      @task = @project.stories.first.tasks.first
      @task.nametags.create(:user => @user)
    end
    should "return the correct count" do
      result = { @user.id => 1 }
      assert_equal result, @project.nametags_count
    end
  end
  
  
end

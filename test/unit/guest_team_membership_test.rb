require File.dirname(__FILE__) + '/../test_helper'

class GuestTeamMembershipTest < ActiveSupport::TestCase
  context "GuestTeamMembership" do
    ################################################################################################################
    #
    # Validations
    #
    ################################################################################################################
    # This is commented because we wan't a different error message, see 'When creating a GuestTeamMembership' context
    # should_validate_presence_of :user, :project
    
    ################################################################################################################
    #
    # Associations
    #
    ################################################################################################################
    should_belong_to :team
    should_belong_to :project
    should_belong_to :user
  end

  context "When creating a GuestTeamMembership" do
    setup do
      @user = Factory(:user)
      @project = Factory(:project)
      @team_membership = GuestTeamMembership.new(:user => @user, :project => @project)
    end

    should "be saved if all the data is present" do
      assert @team_membership.save
    end

    context "if user is not present" do
      setup do
        @team_membership = GuestTeamMembership.new(:project => @project)
      end
    
      should "return an error" do
        assert !@team_membership.save
        assert_equal [ 'user', ": There is no user with that E-mail."], @team_membership.errors.first
      end
    end
    
    context "if project is not present" do
      setup do
        @team_membership = GuestTeamMembership.new(:user => @user)
      end
    
      should "return an error" do
        assert !@team_membership.save
        assert_equal [ 'project', ": You must select a project"], @team_membership.errors.first
      end
    end
    
    context "if the user belongs to the organization " do
      setup do
        @project.organization.users << @user
        @project.save
        @project.reload
        @team_membership = GuestTeamMembership.new(:project => @project, :user => @user)
      end

      should "return an error" do
        assert !@team_membership.save
        assert_equal ["base", "That user belongs to the organization you're administering, there is no need to add it as a guest"], @team_membership.errors.first
      end
    end

    context "if the user is already a guest member" do
      setup do
        @team_membership = GuestTeamMembership.new(:project => @project, :user => @user)
        @team_membership.save
        @team_membership = GuestTeamMembership.new(:project => @project, :user => @user)
        
      end

      should "return an error" do
        assert !@team_membership.save
        assert_equal ["base", "That user is already a guest member on #{@project.name}"], @team_membership.errors.first
      end
    end
    
    
  end
  
  
  # test "hash to array without index" do
  #   hash = HashWithIndifferentAccess.new("0" => 0, "1" => 1, "2" => 2)
  #   array = hash.to_a_with_no_index
  #   assert_equal [0,1,2], array
  # end
  # 
  
  ################################################################################################################
  #
  # Class Methods
  #
  ################################################################################################################
  
  context "#remove_from_project" do
    setup do
      @project = Factory(:project)
      @user = Factory(:user)
      @project.guest_team_memberships.build(:user => @user)
      @project.save
      GuestTeamMembership.remove_from_project(@user, @project)
      @project.reload
    end

    should "remove the user" do
      assert !@project.guest_members.include?(@user)
    end
    
    context "when the user has nametags" do
      setup do
        @project = Factory(:project)
        @project.stories.first.tasks.first.nametags.create(:user => @user)
        @project.save
        @project.reload
        assert !@project.stories.first.tasks.first.nametags.empty?
        @project.guest_team_memberships.build(:user => @user)
        @project.save
        @project.reload
        GuestTeamMembership.remove_from_project(@user, @project)
        @project.stories.first.tasks.first.reload
      end
      should "remove the user" do
        assert !@project.guest_members.include?(@user)
      end
      should "remove the nametags" do
        assert @project.stories.first.tasks.first.nametags.empty?
      end
    end
  end
  
  context "#remove_from_organization" do
    setup do
      @organization = Factory(:organization)
      @user = Factory(:user)
      @project = @organization.projects.first
      @project.guest_team_memberships.build(:user => @user)
      @project.save
      @project.reload
      assert @project.guest_members.include?(@user)
      GuestTeamMembership.remove_from_organization(@user, @organization)
      @organization.reload
    end

    should "remove the user" do
      assert !@project.guest_members.include?(@user)
      assert !@organization.users.include?(@user)
    end
  end
end

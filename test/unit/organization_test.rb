require File.dirname(__FILE__) + '/../test_helper'

class OrganizationTest < ActiveSupport::TestCase
  context "Organization" do
    setup do
      Factory(:organization)
    end
    ################################################################################################################
    #
    # Validations
    #
    ################################################################################################################
    should_validate_presence_of :name
    should_validate_uniqueness_of :name
    ################################################################################################################
    #
    # Associations
    #
    ################################################################################################################
    should_have_many :projects
    should_have_many :teams
    should_have_many :organization_memberships
    should_have_many :users
  end
  
  context "When an organization is created" do
    setup do
      @organization = Organization.create(:name => 'Testing Inc.')
    end

    should "create a default team with name '[organization.name] Team'" do
      assert_equal 1, @organization.teams.size
      assert_equal 'Testing Inc. Team', @organization.teams.first.name
    end

    should "create a default project with name '[organization.name] Project'" do
      assert_equal 1, @organization.projects.size
      assert_equal 'Testing Inc. Project', @organization.projects.first.name
    end
    
    should "assing the default team to the project" do
      assert_equal @organization.projects.first.teams.first, @organization.teams.first
      assert_equal @organization.teams.first.projects.first, @organization.projects.first
    end
  end
  
  context "#users_ordered_by_role" do
    setup do
      @organization = Factory(:organization)
      @org_admin = Factory(:user)
      @organization.organization_memberships.create(:user => @org_admin)

      @admin = Factory(:user)
      @admin.toggle_admin!
      @organization.organization_memberships.create(:user => @admin)

      @user = Factory(:user)
      @organization.organization_memberships.create(:user => @user)
    end

    should "return the system admins, then organization admins and finally normal users" do
      assert_equal [ @admin, @org_admin, @user ], @organization.users_ordered_by_role
    end
  end
  
  context "#teams_ordered_for_user" do
    setup do
      @user = Factory(:user)
      @organization = Factory(:organization)
      @organization.organization_memberships.create(:user => @user)
      @organization.teams.build(:name => "Team Test")
      @organization.teams.first.users.delete(@user)
      @organization.teams.first.save
      @organization.teams.second.users << @user
      @organization.teams.second.save
    end

    should "return first the teams where the user belongs and then the others" do
      assert_equal [ @organization.teams.second, @organization.teams.first ], @organization.teams_ordered_for_user(@user)
    end
  end
  
  context "#projects_ordered_for_user" do
    setup do
      @user = Factory(:user)
      @organization = Factory(:organization)
      @organization.organization_memberships.create(:user => @user)
      @organization.teams.first.users.delete(@user)
      
      @team = @organization.teams.build(:name => "Team Test")
      @organization.save
      @team.users << @user

      @project = @organization.projects.build(:name => "Project Test")
      @project.teams << @team

      @project.save
      @organization.save
    end

    should "return first the teams where the user belongs and then the others" do
      assert_equal [ @organization.projects.second, @organization.projects.first ], @organization.projects_ordered_for_user(@user)
    end
  end

  context "#guest_members" do
    setup do
      @user = Factory(:user)
      @organization = Factory(:organization)
      @project = Factory(:project)
      @team_membership = GuestTeamMembership.new(:user => @user, :project => @project)
    end

    should "return the guest members for the organization" do
      assert [ @user ], @organization.guest_members
    end
  end
  
  context "#admins" do
    setup do
      @user = Factory(:user)
      @organization = Factory(:organization)
      @user.add_to_organization(@organization)
    end

    should "return the admins for the organization" do
      assert_equal [ @user ], @organization.admins
    end
  end
  
  context "#users_out_of_team" do
    setup do
      @user = Factory(:user)
      @organization = Factory(:organization)
      @user.add_to_organization(@organization)
      @team = @organization.teams.first
      @team.users.delete(@user)
    end

    should "return all the users if the team is empty" do
      assert @organization.users_out_of_team(@team).include?(@user)
    end
    
    context "if there are users in the team" do
      setup do
        @team.users << @user
      end

      should "does't have to show that users" do
        assert !@organization.users_out_of_team(@team).include?(@user)
      end
    end
    
  end
  
end

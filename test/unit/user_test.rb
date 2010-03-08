require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  should_have_attached_file :avatar

  context "User" do
    setup do
      Factory(:user)
    end

    ################################################################################################################
    #
    # Validations
    #
    ################################################################################################################
    should_validate_presence_of :email, :login
    should_allow_values_for :email, "contacto@basketplace.com", "test@test.com"
    should_not_allow_values_for :email, "blo", "sao@sadf", "asdasdg@sadasdg.asioghd"
  
    ################################################################################################################
    #
    # Associations
    #
    ################################################################################################################
    should_have_and_belong_to_many :teams
    should_have_many :organization_memberships
    should_have_many :guest_team_memberships
    should_have_many :guest_projects

    # context "If i destroy a user" do
    #   # ...
    #   should "destroy all its organization memberships" do
    #   end
    # end
  end
  
  ################################################################################################################
  #
  # Instance Methods
  #
  ################################################################################################################
  context "#toggle_admin!" do
    setup do
      @user = Factory(:user)
    end

    should "set the user as admin" do
      assert !@user.admin?
      @user.toggle_admin!
      assert @user.admin?
      @user.toggle_admin!
      assert !@user.admin?
    end
  end
  
  context "#organizations_administered" do
    setup do
      @user = Factory(:user)
      @organization = Factory(:organization)
      @user.organization_memberships.create(:organization => @organization)
      @user.organization_memberships.create(:organization => @organization1)
      @user.organization_memberships.second.admin = false
      @user.organization_memberships.second.save
      @user.save
    end
  
    should "return the organization the user admins" do
      assert_equal [ @organization ], @user.organizations_administered
    end
    
    context "when the user is admin" do
      setup do
        @user.admin = true
        @user.save
      end

      should "return all the organizations in the system" do
        assert_equal Organization.all, @user.organizations_administered
      end
    end
  end # End #organizations_administered
  
  context "#admins_any_organization?" do
    setup do
      @organization = Factory(:organization)
      @user1 = Factory(:user)
      @user2 = Factory(:user)
      @user2.organization_memberships.create(:organization => @organization)
      @user1.organization_memberships.create(:organization => @organization)
      @organization1 = Factory(:organization)
    end

    context "if the user doesn't admin any organization" do
      should "return false" do
        assert !@user1.admins_any_organization?
      end
    end

    context "if the user doesn't admins organizations" do
      setup do
        @user1.organization_memberships.create(:organization => @organization1)
        @user1.save
      end

      should "return false" do
        assert @user1.admins_any_organization?
      end
    end

    context "if the user is a system administrator" do
      setup do
        @user2.admin = true
        @user2.save
      end
      should "return true" do
        assert @user2.admins_any_organization?
      end
    end
    
  end # End #admins_any_organization?
  
  context "#admins?" do
    setup do
      @organization = Factory(:organization)
      @user1 = Factory(:user)
      @user2 = Factory(:user)
      @user2.organization_memberships.create(:organization => @organization)
      @user1.organization_memberships.create(:organization => @organization)
    end
    
    context "if the user administers the organization" do
      should "return true" do
        assert @user2.admins?(@organization)
      end
    end

    context "if the user doesn't administer the organization" do
      should "return false" do
        assert !@user1.admins?(@organization)
      end
    end
  end # End #admins?

  context "#projects" do
    setup do
      @team = Factory(:team)
      @project = Factory(:project)
      @project.teams << @team
      @user = Factory(:user)
      # Add the user to a team in a project
      @team.users << @user
    end
    
    should "return the projects where the user is working" do
      assert_equal [ @project ], @user.projects
    end
    
    context "if the user is a guest team member" do
      setup do
        @project2 = Factory(:project)
        @team_membership = GuestTeamMembership.new(:user => @user, :project => @project2)
        @team_membership.save
      end
      
      should "return also the projects where the user is guest" do
        assert_equal [ @project, @project2], @user.projects
      end
    end
  end # End #projects

  # context "#guest_projects" do
  #   setup do
  #     @dfaraday = Factory(:dfaraday)
  #     @project2 = Factory(:do_weird_experiments)
  #     @team = Factory(:dharma_team)
  #     @team_membership = GuestTeamMembership.new(:user => @dfaraday, :project => @project2, :team => @team)
  #     @team_membership.save
  #   end
  #   
  #   should "return the projects where the user is guest" do
  #     assert_equal [ @project2 ], @dfaraday.guest_projects
  #   end
  # end # End #projects

  # context "When creating a user" do
  #   setup do
  #     ActionMailer::Base.deliveries.clear
  #     assert ActionMailer::Base.deliveries.empty?
  #     @john = User.create(:name => 'John Locke', :login => 'jlocke', :email => 'john@locke.com', )
  #   end
  # 
  #   should "send a confirmation e-mail" do
  #     
  #   end
  # end
  # 
  # test "members should be sent an email after their user has been created" do
  # end
  
end

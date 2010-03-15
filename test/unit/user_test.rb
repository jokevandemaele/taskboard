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
    should_validate_uniqueness_of :email, :login
    should_allow_values_for :email, "contacto@basketplace.com", "test@test.com"
    should_not_allow_values_for :email, "blo", "sao@sadf", "asdasdg@sadasdg.asioghd"
    should_allow_values_for :login, "user"
    should_not_allow_values_for :login, "x", "", "hugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhug"
  
    ################################################################################################################
    #
    # Associations
    #
    ################################################################################################################
    should_have_and_belong_to_many :teams
    should_have_many :organization_memberships
    should_have_many :guest_team_memberships
    should_have_many :guest_projects
    should_belong_to :last_project
    should_have_many :nametags
    
    should "have a getter and setter called 'added_by'" do
      # This is used to tell the user in the welcome email who added him
      @user = User.first
      assert @user.added_by = "Me"
      assert_equal "Me", @user.added_by
    end

  end
  
  context "When created" do
    setup do
      ActionMailer::Base.deliveries.clear
      assert ActionMailer::Base.deliveries.empty?
      @user = Factory(:user)
    end

    should "send an email" do
      assert !ActionMailer::Base.deliveries.empty?
    end

    context "with the :new_organization parameter" do
      setup do
        @organization = Factory(:organization)
        @user = Factory.build(:user)
        @user.new_organization = @organization
        @user.save
        @organization.reload
      end

      should "add the user to the organization after being created" do
        assert @organization.users.include?(@user)
      end
    end
  end
  
  # test "members should be sent an email after their user has been created" do
  # 
  #   john = Member.create(:name => 'John Locke', :username => 'jlocke', :email => 'john@locke.com', :new_organization => 1, :added_by => 'Charles Widmore')
  # 
  #   email = MemberMailer.deliver_create(john)
  # end
  
  
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
      @organization.reload
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
      @om1 = OrganizationMembership.create(:user => @user2, :organization => @organization)
      @organization.reload
      @om2 = OrganizationMembership.create(:user => @user1, :organization => @organization)
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

  context "#add_to_organization" do
    setup do
      @organization = Factory(:organization)
      @user = Factory(:user)
      @user.add_to_organization(@organization)
      @organization.reload
    end

    should "add the user to the organization" do
      assert @organization.users.include?(@user)
      assert @user.organizations.include?(@organization)
    end
  end

  context "#remove_from_organization" do
    setup do
      @organization = Factory(:organization)
      @user = Factory(:user)
      @user.add_to_organization(@organization)
      @organization.teams.first.users << @user
      @organization.reload
      assert @organization.users.include?(@user)
      assert @user.organizations.include?(@organization)
      assert @organization.teams.first.users.include?(@user)
      @user.remove_from_organization(@organization)
    end

    should "remove the user from organization" do
      assert !@organization.users.include?(@user)
    end
    should "remove the user from the organization teams as well" do
      assert !@organization.teams.first.users.include?(@user)
    end
  end
  
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

  context "#formatted_nametag" do
    setup do
      @user = Factory(:user)
    end

    should "return a capitalized version of the user name" do
      assert_equal "USER", @user.formatted_nametag
    end
    
    context "When there is more than one user with the same name in a team" do
      setup do
        @team = Factory(:team)
        @user.name = "User Blo"
        @user.save
        @user2 = Factory.build(:user)
        @user2.name = "User Name"
        @user2.save
        @team.users << @user
        @team.users << @user2
        @team.save
      end

      should "return a capitalized version of the user name with initial of surname" do
        assert_equal "USER B", @user.formatted_nametag(@team)
      end

      should "return a capitalized version of the user name with initial of surname when not giving the team" do
        assert_equal "USER B", @user.formatted_nametag
      end
    end
  end

  context "#administrators" do
    setup do
      @org_admin = Factory(:user)
      @organization = Factory(:organization)
      @organization.organization_memberships.build(:user => @org_admin)
      @organization.save
      @organization.reload

      @org_admin2 = Factory(:user)
      @organization2 = Factory(:organization)
      @organization2.organization_memberships.build(:user => @org_admin2)
      @organization2.save
      @organization2.reload

      @user = Factory(:user)
      @organization.organization_memberships.build(:user => @user)
      @organization.save
      @organization.reload
      
      @organization2.organization_memberships.build(:user => @user)
      @organization2.save
      @organization2.reload
    end

    should "return the organization admins for the organizations the user belongs to" do
      assert_equal [@org_admin, @org_admin2], @user.administrators
    end
  end

end

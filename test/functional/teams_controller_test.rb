require File.dirname(__FILE__) + '/../test_helper'

class TeamsControllerTest < ActionController::TestCase
  context "Permissions" do
    should_require_user_on_with_organization_id [ :team_info ]
    should_require_organization_admin_on [ :show, :new, :create, :edit, :update, :destroy ]
    should_require_organization_admin_on_with_user_id [ :add_user, :remove_user ]
  end
  # ----------------------------------------------------------------------------------------------------------------
  # Routes
  # ----------------------------------------------------------------------------------------------------------------
  context "Team Routes" do
    should_route :get, "/organizations/1/teams/new", :action => :new, :organization_id => 1
    should_route :post, "/organizations/1/teams", :action => :create, :organization_id => 1
    should_route :get, "/organizations/1/teams/2/edit", :action => :edit, :id => 2, :organization_id => 1
    should_route :put, "/organizations/1/teams/2", :action => :update, :id => 2, :organization_id => 1
    should_route :delete, "/organizations/1/teams/2", :action => :destroy, :id => 2, :organization_id => 1
    # Edit users
    should_route :post, "/organizations/1/teams/2/users/3", :action => :add_user, :organization_id => 1, :id => 2, :user_id => 3
    should_route :delete, "/organizations/1/teams/2/users/3", :action => :remove_user, :organization_id => 1, :id => 2, :user_id => 3
    # Team Info
    should_route :get, "/organizations/1/teams/2/team_info", :action => :team_info, :organization_id => 1, :id => 2
    
  end

  # ----------------------------------------------------------------------------------------------------------------
  # Normal User
  # ----------------------------------------------------------------------------------------------------------------
  context "If I'm a normal user" do
    setup do
      @user = Factory(:user)
      @organization = Factory(:organization)
      @orgadmin = Factory(:user)
      @orgadmin.add_to_organization(@organization)
      @user.add_to_organization(@organization)
      @team = @organization.teams.first
      @team.users << @orgadmin
      @team.users << @user
    end

    context "and do GET to :team_info" do
      setup do
        get :team_info, :id => @team.to_param, :organization_id => @organization.to_param
      end
      should_respond_with :ok
      should_assign_to(:team){@team}
      should_render_template :team_info
    end
    
  end
  
  # ----------------------------------------------------------------------------------------------------------------
  # Organization Admin
  # ----------------------------------------------------------------------------------------------------------------
  context "If i'm an organization admin" do
    setup do
      @organization = Factory(:organization)
      @team = @organization.teams.create(:name => "Team Test")
      @user = Factory(:user)
      @user.add_to_organization(@organization)
    end
  
    should "admin the organization" do
      assert @user.admins?(@organization)
    end
  
    context "and do GET to :new" do
      setup do
        get :new, :organization_id => @organization.to_param
      end
      should_respond_with :ok
      should_assign_to(:organization){ @organization }
      should_assign_to(:team)
      should_render_template :new
    end
    
    context "and do a POST to :create.json with correct data" do
      setup do
        @request.env['HTTP_ACCEPT'] = "application/json"
        post :create, :team => { :name => "My Team" }, :organization_id => @organization.to_param
        @team = Team.find_by_name("My Team")
      end
      should_respond_with :created
      should_not_set_the_flash
      should_assign_to(:organization){ @organization }
      should_assign_to(:team)
      
      should "create the team" do
        assert !!@team
      end
      
      should "add the team to the organization" do
        assert @organization.teams.include?(@team)
      end
      
      should "return the team json" do
        assert_match @team.to_json, @response.body
      end
    end
  
    context "and do POST to :create.json with incorrect data" do
      setup do
        @request.env['HTTP_ACCEPT'] = "application/json"
        post :create, :organization_id => @organization.to_param, :team => {}
      end
      should_respond_with :precondition_failed
      should_not_set_the_flash
  
      should "return the errors json" do
        assert_match /can't be blank/, @response.body
      end
    end
    
    context "and do GET to :edit" do
      setup do
        get :edit, :id => @team.to_param, :organization_id => @organization.to_param
      end
      should_respond_with :ok
      should_not_set_the_flash
      should_assign_to(:organization){ @organization }
      should_assign_to(:team){ @team }
      should_render_template :edit
    end
    
    context "and do a PUT to :update.json with correct data" do
      setup do
        @request.env['HTTP_ACCEPT'] = "application/json"
        put :update, :id => @team.to_param, :organization_id => @organization.to_param, :team => { :name => "Team Test 2" }
        @team = Team.find_by_name("Team Test 2")
      end
      should_respond_with :ok
      should_not_set_the_flash
      should_assign_to(:organization){ @organization }
      should_assign_to(:team){ @team }
      should "update the team" do
        assert !!@team
      end
      
      should "return the project json" do
        assert_match @team.to_json, @response.body
      end
    end
    
    context "and do a PUT to :update.json with incorrect data" do
      setup do
        @request.env['HTTP_ACCEPT'] = "application/json"
        put :update, :id => @team.to_param, :organization_id => @organization.to_param, :team => { :name => "" }
      end
      should_respond_with :precondition_failed
      should_not_set_the_flash
      should_assign_to(:organization){ @organization }
      should_assign_to(:team){ @team }
      
      should "return the errors json" do
        assert_match /can't be blank/, @response.body
      end
    end
    
    context "and do DELETE to :destroy.json" do
      setup do
        @request.env['HTTP_ACCEPT'] = "application/json"
        delete :destroy, :id => @team.to_param, :organization_id => @organization.to_param
      end
      should_respond_with :ok
      should_not_set_the_flash
      should_assign_to(:organization){ @organization }
      should_assign_to(:team){ @team }
      
      should "destroy the team" do
        assert_raise ActiveRecord::RecordNotFound do
            @team.reload
        end
      end
    end
    
    context "and do GET to :show an organization I administer" do
      setup do
        get :show, :id => @team.to_param, :organization_id => @organization.to_param
      end
      should_respond_with :ok
      should_assign_to(:organization){ @organization }
      should_assign_to(:team){ @team }
      should_render_template :show
    end

    context "and do GET to :show an organization I don't administer" do
      setup do
        @organization = Factory(:organization)
        @team = @organization.teams.first
        get :show, :id => @team.to_param, :organization_id => @organization.to_param
      end
      should_set_the_flash_to("Access Denied")
      should_redirect_to("the root page"){ root_url }
    end
    
    context "and do POST to :add_user with a team I admin" do
      setup do
        @user2 = Factory(:user)
        @user2.add_to_organization(@organization)
        post :add_user, :id => @team.to_param, :organization_id => @organization.to_param, :user_id => @user2.to_param
      end
      should_respond_with :ok
      should_assign_to(:organization){ @organization }
      should_assign_to(:team){ @team }
      should "add the user to the team" do
        assert @team.users.include?(@user2)
      end
      context "and add it again" do
        setup do
          post :add_user, :id => @team.to_param, :organization_id => @organization.to_param, :user_id => @user2.to_param
        end
        should_respond_with :precondition_failed
        should "give an error" do
          assert_match 'is already a team member', @response.body
        end
      end
      
    end

    context "and do POST to :add_user with a team I don't admin" do
      setup do
        @organization2 = Factory(:organization)
        @user2 = Factory(:user)
        @user2.add_to_organization(@organization2)
        @team2 = @organization2.teams.first
        post :add_user, :id => @team2.to_param, :organization_id => @organization2.to_param, :user_id => @user2.id
      end
      should_set_the_flash_to("Access Denied")
      should_redirect_to("the root page"){ root_url }
    end

    context "and do DELETE to :remove_user with a team I admin" do
      setup do
        @user2 = Factory(:user)
        @user2.add_to_organization(@organization)
        @team.users << @user2
        assert @team.users.include?(@user2)
        delete :remove_user, :id => @team.to_param, :organization_id => @organization.to_param, :user_id => @user2.to_param
      end
      should_respond_with :ok
      should_assign_to(:organization){ @organization }
      should_assign_to(:team){ @team }
      should "remove the user from the team" do
        assert !@team.users.include?(@user2)
      end
      
    end

    context "and do DELETE to :add_user with a team I don't admin" do
      setup do
        @organization2 = Factory(:organization)
        @user2 = Factory(:user)
        @user2.add_to_organization(@organization2)
        @team2 = @organization2.teams.first
        delete :remove_user, :id => @team2.to_param, :organization_id => @organization2.to_param, :user_id => @user2.id
      end
      should_set_the_flash_to("Access Denied")
      should_redirect_to("the root page"){ root_url }
    end
    
  end

  # ----------------------------------------------------------------------------------------------------------------
  # System Admin
  # ----------------------------------------------------------------------------------------------------------------
  context "If I'm an admin" do
    setup do
      @organization = Factory(:organization)
      @team = @organization.teams.create(:name => "Team Test")
      @user = admin_user
    end
    
    context "and do GET to :new" do
      setup do
        get :new, :organization_id => @organization.to_param
      end
      should_respond_with :ok
      should_assign_to(:organization){ @organization }
      should_assign_to(:team)
      should_render_template :new
    end
    
    context "and do a POST to :create.json with correct data" do
      setup do
        @request.env['HTTP_ACCEPT'] = "application/json"
        post :create, :team => { :name => "My Team" }, :organization_id => @organization.to_param
        @team = Team.find_by_name("My Team")
      end
      should_respond_with :created
      should_not_set_the_flash
      should_assign_to(:organization){ @organization }
      should_assign_to(:team)
      
      should "create the team" do
        assert !!@team
      end
      
      should "add the team to the organization" do
        assert @organization.teams.include?(@team)
      end
      
      should "return the team json" do
        assert_match @team.to_json, @response.body
      end
    end

    context "and do POST to :create.json with incorrect data" do
      setup do
        @request.env['HTTP_ACCEPT'] = "application/json"
        post :create, :organization_id => @organization.to_param, :team => {}
      end
      should_respond_with :precondition_failed
      should_not_set_the_flash

      should "return the errors json" do
        assert_match /can't be blank/, @response.body
      end
    end
    
    context "and do GET to :edit" do
      setup do
        get :edit, :id => @team.to_param, :organization_id => @organization.to_param
      end
      should_respond_with :ok
      should_not_set_the_flash
      should_assign_to(:organization){ @organization }
      should_assign_to(:team){ @team }
      should_render_template :edit
    end
    
    context "and do a PUT to :update.json with correct data" do
      setup do
        @request.env['HTTP_ACCEPT'] = "application/json"
        put :update, :id => @team.to_param, :organization_id => @organization.to_param, :team => { :name => "Team Test 2" }
        @team = Team.find_by_name("Team Test 2")
      end
      should_respond_with :ok
      should_not_set_the_flash
      should_assign_to(:organization){ @organization }
      should_assign_to(:team){ @team }
      should "update the team" do
        assert !!@team
      end
      
      should "return the project json" do
        assert_match @team.to_json, @response.body
      end
    end
    
    context "and do a PUT to :update.json with incorrect data" do
      setup do
        @request.env['HTTP_ACCEPT'] = "application/json"
        put :update, :id => @team.to_param, :organization_id => @organization.to_param, :team => { :name => "" }
      end
      should_respond_with :precondition_failed
      should_not_set_the_flash
      should_assign_to(:organization){ @organization }
      should_assign_to(:team){ @team }
      
      should "return the errors json" do
        assert_match /can't be blank/, @response.body
      end
    end
    
    context "and do DELETE to :destroy.json" do
      setup do
        @request.env['HTTP_ACCEPT'] = "application/json"
        delete :destroy, :id => @team.to_param, :organization_id => @organization.to_param
      end
      should_respond_with :ok
      should_not_set_the_flash
      should_assign_to(:organization){ @organization }
      should_assign_to(:team){ @team }
      
      should "destroy the team" do
        assert_raise ActiveRecord::RecordNotFound do
            @team.reload
        end
      end
    end
    
    context "and do GET to :show an organization I belong to" do
      setup do
        get :show, :id => @team.to_param, :organization_id => @organization.to_param
      end
      should_respond_with :ok
      should_assign_to(:organization){ @organization }
      should_assign_to(:team){ @team }
      should_render_template :show
    end

    context "and do GET to :show an organization I don't belong to" do
      setup do
        @organization = Factory(:organization)
        @team = @organization.teams.first
        get :show, :id => @team.to_param, :organization_id => @organization.to_param
      end
      should_respond_with :ok
      should_assign_to(:organization){ @organization }
      should_assign_to(:team){ @team }
      should_render_template :show
    end
  end
end

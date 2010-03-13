require File.dirname(__FILE__) + '/../test_helper'

class TeamsControllerTest < ActionController::TestCase
  context "Permissions" do
    should_require_organization_admin_on [ :new, :create, :edit, :update, :destroy ]
  end
  # ----------------------------------------------------------------------------------------------------------------
  # Routes
  # ----------------------------------------------------------------------------------------------------------------
  context "Team Routes" do
    # should_route :get, "/organizations/1/teams", :action => :index
    should_route :get, "/organizations/1/teams/new", :action => :new, :organization_id => 1
    should_route :post, "/organizations/1/teams", :action => :create, :organization_id => 1
    should_route :get, "/organizations/1/teams/2/edit", :action => :edit, :id => 2, :organization_id => 1
    should_route :put, "/organizations/1/teams/2", :action => :update, :id => 2, :organization_id => 1
    should_route :delete, "/organizations/1/teams/2", :action => :destroy, :id => 2, :organization_id => 1
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
    
    
  end
  # ########################## Permissions tests ##########################
  # test "show should be seen by administrator and organization admin" do 
  #   login_as_administrator
  #   get :show, :id => 1
  #   assert_response :ok
  # 
  #   login_as_organization_admin
  #   get :show, :id => 1
  #   assert_response :ok
  # 
  #   login_as_normal_user
  #   get :show, :id => 1
  #   assert_response 302
  # end
  # test "new should be seen by administrator and organization admin" do
  #     login_as_administrator
  #     get :new, :organization => organizations(:widmore_corporation).id
  #     assert_response :ok
  #     
  #     login_as_organization_admin
  #     get :new, :organization => organizations(:widmore_corporation).id
  #     assert_response :ok
  #     
  #     # If trying to get form for a organization not administered it shouln't work
  #     get :new, :organization => organizations(:dharma_initiative).id
  #     assert_response 302
  #   
  #     login_as_normal_user
  #     get :new, :organization => organizations(:dharma_initiative).id
  #     assert_response 302
  #   end
  # 
  # test "edit should be seen by administrator and organization admin" do
  #   login_as_administrator
  #   get :edit, :id => teams(:widmore_team).id
  #   assert_response :ok
  # 
  #   login_as_organization_admin
  #   get :edit, :id => teams(:widmore_team).id
  #   assert_response :ok
  # 
  #   login_as_normal_user
  #   get :edit, :id => teams(:widmore_team).id
  #   assert_response 302
  # end
  # 
  # test "a system adminsitrator should be able CREATE, UPDATE and DELETE teams for any organization" do
  #   login_as_administrator
  #   # CREATE to organization where admin belongs
  #   post :create,{ :team => { :name => 'Fucault Pendulum Research Team', :organization_id => organizations(:widmore_corporation).id } }
  #   assert_response :created
  #   team = Team.find_by_name('Fucault Pendulum Research Team')
  #   assert team
  #   assert organizations(:widmore_corporation).teams.include?(team)
  #   
  #   # CREATE to organization where admin doesn't belong
  #   post :create, { :team => {:name => 'Security Team', :organization_id => organizations(:dharma_initiative).id } }
  #   assert_response :created
  #   team_not_mine = Team.find_by_name('Security Team')
  #   assert team_not_mine
  #   assert organizations(:dharma_initiative).teams.include?(team_not_mine)
  #   
  #   # UPDATE from organization where admin belongs
  #   team = Team.find_by_name('Fucault Pendulum Research Team')
  #   put :update, { :id => team.id, :team => {:name => 'Fucault Pendulum Research Team.' } }
  #   assert_response :ok
  #   team.reload
  #   assert_equal 'Fucault Pendulum Research Team.', team.name
  # 
  #   # UPDATE from organization where admin doesn't
  #   team_notmine = Team.find_by_name('Security Team')
  #   put :update, { :id => team_notmine.id, :team => { :name => 'Security Team.' } }
  #   assert_response :ok
  #   team_notmine.reload
  #   assert_equal 'Security Team.', team_notmine.name
  # 
  #   # DELETE from organization where admin belongs
  #   delete :destroy, { :id => team.id }
  #   assert_response :ok
  #   assert_nil Team.find_by_name('Fucault Pendulum Research Team.')
  #   
  #   # DELETE from organization where admin doesn't belong
  #   delete :destroy, { :id => team_notmine.id }
  #   assert_response :ok
  #   assert_nil Team.find_by_name('Security Team.')
  # end
  # 
  # test "an organization admin should be able CREATE, UPDATE and DELETE teams for its organizations" do
  #   login_as_organization_admin
  # 
  #   # CREATE to organization where admin belongs
  #   post :create,{ :team => { :name => 'Fucault Pendulum Research Team', :organization_id => organizations(:widmore_corporation).id } }
  #   assert_response :created
  #   team = Team.find_by_name('Fucault Pendulum Research Team')
  #   assert team
  #   assert organizations(:widmore_corporation).teams.include?(team)
  #   
  #   # UPDATE from organization where admin belongs
  #   team = Team.find_by_name('Fucault Pendulum Research Team')
  #   put :update, { :id => team.id, :team => {:name => 'Fucault Pendulum Research Team.', :organization_id => organizations(:widmore_corporation).id } }
  #   assert_response :ok
  #   team.reload
  #   assert_equal 'Fucault Pendulum Research Team.', team.name
  #   
  #   # DELETE from organization where admin belongs
  #   delete :destroy, { :id => team.id }
  #   assert_response :ok
  #   assert_nil Team.find_by_name('Fucault Pendulum Research Team.')
  # end
  # 
  # test "an organization admin shouldn't be able CREATE, UPDATE and DELETE teams to another organization" do
  #   login_as_organization_admin
  #   
  #   # CREATE to organization where admin doesn't belong
  #   post :create, { :team => {:name => 'Security Team', :organization_id => organizations(:dharma_initiative).id } }
  #   assert_response 302
  #   assert !Team.find_by_name('Security Team')
  #   
  #   # UPDATE from organization where admin doesn't
  #   team_notmine = teams(:oceanic_six)
  #   put :update, { :id => team_notmine.id, :team => { :name => 'Dead People', :organization_id => organizations(:dharma_initiative).id } }
  #   assert_response 302
  #   team_notmine.reload
  #   assert_not_equal 'Dead People', team_notmine.name
  #   
  #   
  #   # DELETE from organization where admin doesn't belong
  #   delete :destroy, { :id => team_notmine.id }
  #   assert_response 302
  #   assert Team.find(team_notmine.id)
  # end 
  # 
  # test "a normal user shouldn't be able to CREATE, UPDATE and DELETE teams to any organization" do
  #   login_as_normal_user
  #   
  #   # CREATE
  #   post :create, { :team => {:name => 'Security Team', :organization_id => organizations(:widmore_corporation).id } }
  #   assert_response 302
  #   assert !Team.find_by_name('Security Team')
  #   
  #   # UPDATE
  #   team_notmine = teams(:oceanic_six)
  #   put :update, { :id => team_notmine.id, :team => { :name => 'Dead People', :organization_id => organizations(:widmore_corporation).id } }
  #   assert_response 302
  #   team_notmine.reload
  #   assert_not_equal 'Dead People', team_notmine.name
  #   
  #   
  #   # DELETE
  #   delete :destroy, { :id => team_notmine.id }
  #   assert_response 302
  #   assert Team.find(team_notmine.id)  
  # end
  # 
  # test "an organization admin should be able to add & remove members for teams within its organizations" do
  #   login_as_organization_admin
  # 
  #   # ADD MEMBER with team and member belonging to organization
  #   post :add_member,{ :team => teams(:widmore_team), :member => members(:cwidmore) }
  #   assert_response :ok
  #   assert teams(:widmore_team).members.include?(members(:cwidmore))
  # 
  #   # ADD MEMBER with team belonging to organization
  #   post :add_member,{ :team => teams(:widmore_team), :member => members(:mdawson) }
  #   assert_response 302
  #   assert !teams(:widmore_team).members.include?(members(:mdawson))
  #   
  #   # ADD MEMBER with member belonging to organization
  #   post :add_member,{ :team => teams(:oceanic_six), :member => members(:clittleton) }
  #   assert_response 302
  #   assert !teams(:oceanic_six).members.include?(members(:clittleton))
  # 
  #   # ADD MEMBER with none belonging to organization
  #   post :add_member,{ :team => teams(:oceanic_six), :member => members(:mdawson) }
  #   assert_response 302
  #   assert !teams(:oceanic_six).members.include?(members(:mdawson))
  # 
  #   # REMOVE MEMBER with team and member belonging to organization
  #   post :remove_member,{ :team => teams(:widmore_team), :member => members(:cwidmore) }
  #   assert_response :ok
  #   assert !teams(:widmore_team).members.include?(members(:cwidmore))
  # 
  #   # REMOVE MEMBER with none belonging to organization
  #   post :remove_member,{ :team => teams(:oceanic_six), :member => members(:jshephard) }
  #   assert_response 302
  #   assert teams(:oceanic_six).members.include?(members(:jshephard))
  #   
  # end
  # 
end

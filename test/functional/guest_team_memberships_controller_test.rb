require File.dirname(__FILE__) + '/../test_helper'

class GuestTeamMembershipsControllerTest < ActionController::TestCase
  # context "Permissions" do
  #   should_require_organization_admin_on_with_project_id [:new, :create, :destroy ]
  # end
  # 
  # # ----------------------------------------------------------------------------------------------------------------
  # # Routes
  # # ----------------------------------------------------------------------------------------------------------------
  # context "Routes" do
  #   should_route :get, "/organizations/1/guest_team_memberships/new", :action => :new, :organization_id => 1
  #   should_route :post, "/organizations/1/projects/2/guest_team_memberships", :action => :create, :organization_id => 1, :project_id => 2
  #   should_route :delete, "/organizations/1/projects/2/guest_team_memberships/3", :action => :destroy, :organization_id => 1, :project_id => 2, :id => 3
  # end
  # 
  # # ----------------------------------------------------------------------------------------------------------------
  # # Organization Admin
  # # ----------------------------------------------------------------------------------------------------------------
  # context "If i'm an organization admin" do
  #   setup do
  #     @project = Factory(:project)
  #     @organization = @project.organization
  #     @user = Factory(:user)
  #     @user.add_to_organization(@organization)
  #     @user2 = Factory(:user)
  #   end
  #   
  #   should "admin the organization" do
  #     assert @user.admins?(@organization)
  #   end
  #   
  #   context "and do GET to :new" do
  #     setup do
  #       get :new, :organization_id => @organization.to_param
  #     end
  #     should_respond_with :ok
  #     should_assign_to(:organization){ @organization }
  #     should_render_template :new
  #   end
  #   
  #   context "and do a POST to :create.json with correct data" do
  #     setup do
  #       ActionMailer::Base.deliveries.clear
  #       assert ActionMailer::Base.deliveries.empty?
  # 
  #       @request.env['HTTP_ACCEPT'] = "application/json"
  #       post :create, :organization_id => @organization.to_param, :project_id => @project.to_param, :email => @user2.email
  #       @guest_team_membership = GuestTeamMembership.first(:conditions => ['project_id = ? AND user_id = ?', @project.to_param, @user2.to_param])
  #     end
  #     
  #     should_respond_with :created
  #     should_not_set_the_flash
  #     should_assign_to(:organization){ @organization }
  #     should_assign_to(:project){ @project }
  #     should_assign_to(:guest_team_membership)
  #     
  #     should "create the guest_team_membership" do
  #       assert !!@guest_team_membership
  #     end
  #     
  #     should "return the guest_team_membership json" do
  #       assert_match @guest_team_membership.to_json, @response.body
  #     end
  #      
  #     should "send an email to the user" do
  #       assert !ActionMailer::Base.deliveries.empty?
  #     end
  #   end
  # 
  #   context "and do a POST to :create.json with an already guest team member" do
  #     setup do
  #       ActionMailer::Base.deliveries.clear
  #       assert ActionMailer::Base.deliveries.empty?
  # 
  #       @request.env['HTTP_ACCEPT'] = "application/json"
  #       post :create, :organization_id => @organization.to_param, :project_id => @project.to_param, :email => @user2.email
  #       post :create, :organization_id => @organization.to_param, :project_id => @project.to_param, :email => @user2.email
  #       @guest_team_membership = GuestTeamMembership.first(:conditions => ['project_id = ? AND user_id = ?', @project.to_param, @user2.to_param])
  #     end
  #     should_respond_with :precondition_failed
  #     should_not_set_the_flash
  #     should_assign_to(:organization){ @organization }
  #     should_assign_to(:project){ @project }
  #     should_assign_to(:guest_team_membership)
  #     
  #     should "return the guest_team_membership json" do
  #       assert_match "That user is already a guest member on #{@project.name}", @response.body
  #     end
  #   end
  # 
  #   context "and do a POST to :create.json with a a user from the organization" do
  #     setup do
  #       ActionMailer::Base.deliveries.clear
  #       assert ActionMailer::Base.deliveries.empty?
  # 
  #       @request.env['HTTP_ACCEPT'] = "application/json"
  #       post :create, :organization_id => @organization.to_param, :project_id => @project.to_param, :email => @user.email
  #     end
  #     should_respond_with :precondition_failed
  #     should_not_set_the_flash
  #     should_assign_to(:organization){ @organization }
  #     should_assign_to(:project){ @project }
  #     should_assign_to(:guest_team_membership)
  #     
  #     should "return the guest_team_membership json" do
  #       assert_match "That user belongs to the organization you're administering, there is no need to add it as a guest", @response.body
  #     end
  #   end
  #   
  #   context "and do DELETE to :destroy.json" do
  #     setup do
  #       @request.env['HTTP_ACCEPT'] = "application/json"
  #       @project.guest_team_memberships.create(:user => @user2)
  #       assert @project.users.include?(@user2)
  #       delete :destroy, :id => @user2.to_param, :organization_id => @organization.to_param, :project_id => @project.to_param
  #     end
  #     should_respond_with :ok
  #     should_not_set_the_flash
  #     should_assign_to(:organization){ @organization }
  #     should_assign_to(:project){ @project }
  #     should_assign_to(:guest_team_membership)
  #     
  #     should "destroy the membership" do
  #       assert @project.users.include?(@user2)
  #     end
  #   end
  #   
  # end
  # 
  # # ----------------------------------------------------------------------------------------------------------------
  # # System Admin
  # # ----------------------------------------------------------------------------------------------------------------
  # context "If I'm an admin" do
  #   setup do
  #     @organization = Factory(:organization)
  #     @user = admin_user
  #   end
  # 
  # end
  
end
require 'test_helper'

class OrganizationsControllerTest < ActionController::TestCase
  should_require_user :index
  # test "show displays the organization" do
  #   login_as_administrator
  #   result = get :show, :id => organizations(:widmore_corporation).id
  #   assert_select "div#organization-#{organizations(:widmore_corporation).id}-container", 1
  # end
  # ########################## Permissions tests ##########################
  # test "index should be seen by all" do
  #   login_as_administrator
  #   get :index
  #   assert_response :ok
  #   
  #   login_as_organization_admin
  #   get :index
  #   assert_response :ok
  # 
  #   login_as_normal_user
  #   get :index
  #   assert_response :ok
  # end
  # 
  # test "new should be seen by administrator only" do
  #   login_as_administrator
  #   get :new
  #   assert_response :ok
  #   # Organization admin should be able to see new only if admins the current organization
  #   login_as_organization_admin
  #   get :new
  #   assert_response 302
  # 
  #   login_as_normal_user
  #   get :new
  #   assert_response 302
  # end
  # 
  # test "edit should be seen by administrator and organization admin" do
  #   login_as_administrator
  #   get :edit, :id => 1
  #   assert_response :ok
  #   
  #   login_as_organization_admin
  #   get :edit, :id => 1
  #   assert_response :ok
  # 
  #   login_as_normal_user
  #   get :edit, :id => 1
  #   assert_response 302
  # end
  # 
  # test "a system adminsitrator should be able CREATE, UPDATE and DELETE organizations" do
  #   login_as_administrator
  #   # CREATE organization
  #   post :create, :organization => { :name => 'Oxford University college' }
  #   assert_response :created
  #   assert Organization.find_by_name('Oxford University college')
  # 
  #   # UPDATE organization where admin belongs
  #   organization = organizations(:widmore_corporation)
  #   put :update, { :id => organization.id, :organization => { :name => 'Widmore Corporation..' } }
  #   assert_response :ok
  #   organization.reload
  #   assert_equal 'Widmore Corporation..', organization.name
  # 
  #   # UPDATE organization where admin doesn't belong
  #   org_notmine = Organization.find_by_name('Oxford University college')
  #   put :update, { :id => org_notmine.id, :organization => { :name => 'Oxford University college.' } }
  #   assert_response :ok
  #   org_notmine.reload
  #   assert_equal 'Oxford University college.', org_notmine.name
  #   
  #   # DELETE organization
  #   delete :destroy, { :id => org_notmine.id }
  #   assert_response :ok
  #   assert_nil Organization.find_by_name('Oxford University college.')
  # end
  # 
  # test "an organization admin should be able to UPDATE its organizations" do
  #   login_as_organization_admin
  # 
  #   # CREATE organization
  #   post :create, :organization => { :name => 'Oxford University college' }
  #   assert_response 302
  #   assert !Organization.find_by_name('Oxford University college')
  #   
  #   # UPDATE organization where admin belongs
  #   organization = organizations(:widmore_corporation)
  #   put :update, { :id => organization.id, :organization => { :name => 'Widmore Corporation.' } }
  #   assert_response :ok
  #   organization.reload
  #   assert_equal 'Widmore Corporation.', organization.name
  # 
  #   # UPDATE organization admin doesn't admin
  #   organization = organizations(:oceanic_six)
  #   put :update, { :id => organization.id, :organization => { :name => 'Kill them all.' } }
  #   assert_response 302
  #   organization.reload
  #   assert_not_equal 'Kill them all.', organization.name
  #   
  #   # DELETE organization
  #   delete :destroy, { :id => organization }
  #   assert_response 302
  #   assert Organization.find_by_name('Widmore Corporation.')
  # end
  # 
  # test "a normal user shouldn't be able to CREATE, UPDATE and DELETE teams to any organization" do
  #   login_as_normal_user
  #   
  #   # CREATE
  #   post :create, :organization => { :name => 'Oxford University college' }
  #   assert_response 302
  #   assert !Organization.find_by_name('Oxford University college')
  #   
  #   # UPDATE
  #   organization = organizations(:oceanic_six)
  #   put :update, { :id => organization.id, :organization => { :name => 'Kill them all.' } }
  #   assert_response 302
  #   organization.reload
  #   assert_not_equal 'Kill them all.', organization.name
  # 
  #   # DELETE
  #   delete :destroy, { :id => organization }
  #   assert_response 302
  #   assert Organization.find_by_name('Oceanic Six')
  # end
  # 
  # test "a system administrator should be able to toggle admin for any user" do
  #   login_as_administrator
  #   # Toggle admin in own organization
  #   get :toggle_admin, { :id => organizations(:widmore_corporation).id, :member => members(:dfaraday).id }
  #   assert_response :ok
  #   assert members(:dfaraday).admins?(organizations(:widmore_corporation))
  #   get :toggle_admin, { :id => organizations(:widmore_corporation).id, :member => members(:dfaraday).id }
  #   assert_response :ok
  #   assert !members(:dfaraday).admins?(organizations(:widmore_corporation))
  #   
  #   # Toggle admin in foreign organization
  #   get :toggle_admin, { :id => organizations(:oceanic_six).id, :member => members(:kausten).id }
  #   assert_response :ok
  #   assert members(:kausten).admins?(organizations(:oceanic_six))
  #   get :toggle_admin, { :id => organizations(:oceanic_six).id, :member => members(:kausten).id }
  #   assert_response :ok
  #   assert !members(:kausten).admins?(organizations(:oceanic_six))
  #   
  # end
  # 
  # test "an organization administrator should be able to toggle admin only within its organizations" do
  #   login_as_organization_admin
  #   # Toggle admin in own organization
  #   get :toggle_admin, { :id => organizations(:widmore_corporation).id, :member => members(:dfaraday).id }
  #   assert_response :ok
  #   assert members(:dfaraday).admins?(organizations(:widmore_corporation))
  #   get :toggle_admin, { :id => organizations(:widmore_corporation).id, :member => members(:dfaraday).id }
  #   assert_response :ok
  #   assert !members(:dfaraday).admins?(organizations(:widmore_corporation))
  #   
  #   # Toggle admin in foreign organization
  #   get :toggle_admin, { :id => organizations(:oceanic_six).id, :member => members(:kausten).id }
  #   assert_response 302
  #   assert !members(:kausten).admins?(organizations(:oceanic_six))
  # end
  # 
  # test "a normal user should't be able to toggle admin at all" do
  #   login_as_normal_user
  #   # Toggle admin in own organization
  #   get :toggle_admin, { :id => organizations(:widmore_corporation).id, :member => members(:dfaraday).id }
  #   assert_response 302
  #   assert !members(:dfaraday).admins?(organizations(:widmore_corporation))
  #   
  #   # Toggle admin in foreign organization
  #   get :toggle_admin, { :id => organizations(:oceanic_six).id, :member => members(:kausten).id }
  #   assert_response 302
  #   assert !members(:kausten).admins?(organizations(:oceanic_six))
  # end
  # 
  # test "no one should be able to auto toggle admin" do
  #   # Organization admin
  #   login_as_organization_admin
  #   get :toggle_admin, { :id => organizations(:widmore_corporation).id, :member => members(:cwidmore).id }
  #   assert_response :internal_server_error
  #   assert members(:cwidmore).admins?(organizations(:widmore_corporation))
  # end
  # 
  # test "only admin should be able to invite people" do
  #   ActionMailer::Base.deliveries.clear
  #   assert ActionMailer::Base.deliveries.empty?
  # 
  #   login_as_administrator
  #   get :invite
  #   assert_response :ok
  #   post :send_invitation, { :name => "Miles", :organization => "Psicopats", :email => "miles@lost.com"}
  #   assert_response :ok
  #   
  #   assert Organization.find_by_name("Psicopats")
  #   assert member = Member.find_by_username("miles")
  #   assert_equal 'miles@lost.com', member.email
  # 
  #   email = MemberMailer.deliver_create(member)
  #   assert !ActionMailer::Base.deliveries.empty?
  #   assert_equal email.from, ['info@agilar.org']
  #   assert_equal email.to, ['miles@lost.com']
  #   assert_equal email.subject, 'Welcome to the Agilar Taskboard!'
  #   assert_match /Miles/, email.body
  #   assert_match /Psicopats/, email.body
  # 
  #   login_as_organization_admin
  #   get :invite
  #   assert_response 302
  #   get :send_invitation
  #   assert_response 302
  # 
  #   login_as_normal_user
  #   get :invite
  #   assert_response 302
  #   get :send_invitation
  #   assert_response 302
  # end
end

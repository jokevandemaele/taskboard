module RequireOrganizationAdminOnWithProjectId
  def should_require_organization_admin_on_with_project_id(actions = [])
    if actions == :all
      actions = %w{index show new create edit update destroy}.map(&:to_sym)
    else
      actions = Array(actions)
    end

    action_methods = {
      :create  => :post,
      :update  => :put,
      :destroy => :delete
    }

    need_ids = action_methods.keys + [:show, :edit]

    context "SROAOWP: If I'm not logged in" do
      setup do
        @project = Factory(:project)
        @organization = @project.organization
      end

      actions.each do |action|
        method = action_methods[action] || :get

        context "on #{method.to_s.upcase} to :#{action} with organization_id parameter" do
          setup do
            if need_ids.include?(action)
              send(method, action, :id => 1, :organization_id => @organization.to_param, :project_id => @project.to_param)
            else
              send(method, action, :organization_id => @organization.to_param, :project_id => @project.to_param)
            end
          end

          should_set_the_flash_to("Please Login")
          should_redirect_to('the login page') { login_url }
        end
      end
    end

    context "SROAOWP: If I'm a normal user" do
      setup do
        @project = Factory(:project)
        @organization = @project.organization
        @user = Factory(:user)
        @user1 = Factory(:user)
      end

      actions.each do |action|
        method = action_methods[action] || :get

        context "and do #{method.to_s.upcase} to :#{action}" do
          setup do
            if need_ids.include?(action)
              send(method, action, :id => @user1.to_param, :organization_id => @organization.to_param, :project_id => @project.to_param)
            else
              send(method, action, :organization_id => @organization.to_param, :project_id => @project.to_param)
            end
          end

          should_set_the_flash_to("Access Denied")
          should_redirect_to('the root page') { root_url }
        end
      end
    end
  end
end

class ActiveSupport::TestCase
  extend RequireOrganizationAdminOnWithProjectId
end

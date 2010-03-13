module RequireOrganizationAdminOnForOrganizationsController
  def should_require_organization_admin_on_for_organizations_controller(actions = [])
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

    context "SROAOFOC: If I'm not logged in" do
      setup do
        @organization = Factory(:organization)
      end

      actions.each do |action|
        method = action_methods[action] || :get

        context "on #{method.to_s.upcase} to :#{action} with organization_id parameter" do
          setup do
            if need_ids.include?(action)
              send(method, action, :id => @organization.to_param)
            else
              send(method, action, :id => @organization.to_param)
            end
          end

          should_set_the_flash_to("Please Login")
          should_redirect_to('the login page') { login_url }
        end
      end
    end

    context "SROAO: If I'm a normal user" do
      setup do
        @organization = Factory(:organization)
        @user = Factory(:user)
      end

      actions.each do |action|
        method = action_methods[action] || :get

        context "and do #{method.to_s.upcase} to :#{action}" do
          setup do
            if need_ids.include?(action)
              send(method, action, :id => @organization.to_param)
            else
              send(method, action, :organization_id => @organization.to_param)
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
  extend RequireOrganizationAdminOnForOrganizationsController
end

module RequireOrganizationAdminOn
  def should_require_organization_admin_on(actions = [])
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

    context "A user that is not an organization admin" do
      setup do
        @organization = Factory(:organization)
        @user = Factory(:user)
      end

      actions.each do |action|
        method = action_methods[action] || :get

        context "on #{method.to_s.upcase} to :#{action}" do
          setup do
            if need_ids.include?(action)
              send(method, action, :id => 1, :organization_id => @organization.id)
            else
              send(method, action, :organization_id => @organization.id)
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
  extend RequireOrganizationAdminOn
end

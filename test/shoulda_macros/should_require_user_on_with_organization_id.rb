module RequireUserOnWithOrganizationId
  def should_require_user_on_with_organization_id(actions = [])
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

    need_ids = action_methods.keys + [:show, :edit, :team_info]

    context "A not logged in user" do
      setup do
        @organization = Factory(:organization)
        @user = not_logged_user
      end

      actions.each do |action|
        method = action_methods[action] || :get

        context "on #{method.to_s.upcase} to :#{action}" do
          setup do
            if need_ids.include?(action)
              send(method, action, :id => 1, :organization_id => @organization.to_param)
            else
              send(method, action, :organization_id => @organization.to_param)
            end
          end

          should_set_the_flash_to("Please Login")
          should_redirect_to('the login page') { login_url }
        end
      end
    end
  end
end

class ActiveSupport::TestCase
  extend RequireUserOnWithOrganizationId
end

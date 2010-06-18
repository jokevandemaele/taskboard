module RequireOrganizationAdminOnWithUserId
  def should_require_organization_admin_on_with_user_id(actions = [])
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

    need_ids = action_methods.keys + [ :add_user, :remove_user, :show, :edit]

    context "SROAOWU: If I'm not logged in" do
      setup do
        @organization = Factory(:organization)
        @team = @organization.teams.first
        @user = not_logged_user
        @user.add_to_organization(@organization)
      end

      actions.each do |action|
        method = action_methods[action] || :get

        context "on #{method.to_s.upcase} to :#{action} with organization_id parameter" do
          setup do
            if need_ids.include?(action)
              send(method, action, :id => @team.to_param, :organization_id => @organization.to_param, :user_id => @user.to_param)
            else
              send(method, action, :id => @team.to_param, :organization_id => @organization.to_param)
            end
          end

          should_set_the_flash_to("Please Login")
          should_redirect_to('the login page') { login_url }
        end
      end
    end

    context "SROAOWU: If I'm a normal user" do
      setup do
        @user = Factory(:user)
        @organization = Factory(:organization)
        @team = @organization.teams.first
        @user1 = Factory(:user)
      end

      actions.each do |action|
        method = action_methods[action] || :get

        context "and do #{method.to_s.upcase} to :#{action}" do
          setup do
            if need_ids.include?(action)
              send(method, action, :id => @team.to_param, :organization_id => @organization.to_param, :user_id => @user1.to_param)
            else
              send(method, action, :id => @team.to_param, :organization_id => @organization.to_param)
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
  extend RequireOrganizationAdminOnWithUserId
end

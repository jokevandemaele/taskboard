module RequireAdminOn
  def should_require_admin_on(actions)
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

    context "A not logged in user" do
      setup do
        @user = not_logged_user
      end

      actions.each do |action|
        method = action_methods[action] || :get

        context "on #{method.to_s.upcase} to :#{action}" do
          setup do
            if need_ids.include?(action)
              send(method, action, :id => 1)
            else
              send(method, action)
            end
          end

          should_set_the_flash_to('Please Login')
          should_redirect_to('the login page') { login_url }
        end
      end
    end

    context "A normal user" do
      setup do
        @user = Factory(:user)
      end

      actions.each do |action|
        method = action_methods[action] || :get

        context "on #{method.to_s.upcase} to :#{action}" do
          setup do
            if need_ids.include?(action)
              send(method, action, :id => 1)
            else
              send(method, action)
            end
          end

          should_set_the_flash_to("Access Denied")
          should_redirect_to('the root page') { root_url }
        end
      end
    end

    context "An organization admin" do
      setup do
        @organization = Factory(:organization)
        @user = Factory(:user)
        @mem = @organization.organization_memberships.build(:user => @user)
        @mem.admin = true
        @mem.save
      end

      actions.each do |action|
        method = action_methods[action] || :get

        context "on #{method.to_s.upcase} to :#{action}" do
          setup do
            if need_ids.include?(action)
              send(method, action, :id => 1)
            else
              send(method, action)
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
  extend RequireAdminOn
end


module RequireNoUserOn
  def should_require_no_user_on(actions = [])
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

    context "SRNUO: If I'm a normal user" do
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

          should_set_the_flash_to("Please Logout")
          should_redirect_to('the account page') { account_url }
        end
      end
    end
  end
end

class ActiveSupport::TestCase
  extend RequireNoUserOn
end

module RequireOwnAccountOn
  def should_require_own_account_on(actions = [])
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
    context "SROWNAO: If I'm a normal user" do
      setup do
        @user = Factory(:user)
        @user2 = Factory(:user)
      end

      actions.each do |action|
        method = action_methods[action] || :get

        context "on #{method.to_s.upcase} to :#{action} on other's account" do
          setup do
            if need_ids.include?(action)
              send(method, action, :id => @user2.to_param)
            else
              send(method, action)
            end
          end
          should_set_the_flash_to("Access Denied")
          should_redirect_to('the root page') { root_url }
        end
      end
    end

    context "SROWNAO: If I'm an organization admin" do
      setup do
        @user = Factory(:user)
        @user2 = Factory(:user)
      end
      
      context "and admin the organization" do
        setup do
          @organization = Factory(:organization)
          @user.add_to_organization(@organization)
          assert @user.admins?(@organization)
        end

        actions.each do |action|
          method = action_methods[action] || :get

          context "on #{method.to_s.upcase} to :#{action} with organization id" do
            setup do
              if need_ids.include?(action)
                send(method, action, :id => @user2.to_param, :organization_id => @organization.to_param)
              else
                send(method, action, :organization_id => @organization.to_param)
              end
            end
            should_set_the_flash_to("Access Denied")
            should_redirect_to('the root page') { root_url }
          end

          context "on #{method.to_s.upcase} to :#{action} without organization id" do
            setup do
              if need_ids.include?(action)
                send(method, action, :id => @user2.to_param)
              else
                send(method, action)
              end
            end
            should_set_the_flash_to("Access Denied")
            should_redirect_to('the root page') { root_url }
          end
        end
      end
      
      context "and don't own the organization" do
        setup do
         @organization = Factory(:organization) 
        end

        actions.each do |action|
          method = action_methods[action] || :get

          context "on #{method.to_s.upcase} to :#{action}" do
            setup do
              if need_ids.include?(action)
                send(method, action, :id => @user2.to_param, :organization_id => @organization.to_param)
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
end

class ActiveSupport::TestCase
  extend RequireOwnAccountOn
end
